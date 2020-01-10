class EpisodesController < ApplicationController
  skip_before_action :authorized,        only: [:index, :show, :draft] # authorized redirects to root. Draft should redirect to login.
  before_action :set_episode,            only: [:show, :edit, :update, :destroy, :publish] #allow URL to reference slug or episode number
  before_action :set_draft,              only: [:create, :update]
  after_action :create_photo_objects,
               :update_photo_captions, 
               :delete_photo_objects,
               :delete_audio_attachment, only: [:create, :update]

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.all
    respond_to do |format|
      format.html
      format.rss { render :layout => false }  # TODO: Restrict drafts from RSS feed. Add params to allow number of episodes selection.
    end
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
  end

  # GET /episodes/new
  # def new
  # end

  # GET /episodes/1/edit
  def edit
    if @episode.draft?
      redirect_to draft_path
    end
  end

  # GET /draft
  def draft
    unless logged_in?
      session[:pre_login_request] = '/draft'
      redirect_to login_path 
    end
    if Episode.draft_waiting?
      @episode = Episode.most_recent_draft.take
    else
      @episode = Episode.new
      @episode.number = (Episode.maximum('number') || 0) + 1
      @episode.publish_date = DateTime.parse('tuesday') + (DateTime.parse('tuesday') > DateTime.current ? 0:7) # find next tuesday TODO: pull publish date/schedule out into config file
    end
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.new(episode_params)
    previous_slug = @episode.slug
    @episode.slug = build_slug episode_title: @episode.title, episode_slug: @episode.slug
    respond_to do |format|
      if @episode.save
        format.html { redirect_to draft_path, notice: 'Episode was successfully created.' }
        format.json { render :show, status: :created, location: @episode }
      else
        @episode.slug = previous_slug
        format.html { render :draft }
      end
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    previous_slug = @episode.slug
    @episode.slug = build_slug(episode_title: @episode.title, episode_slug: @episode.slug)
    respond_to do |format|
      if @episode.update( episode_params.merge!(slug: @episode.slug) )
        if @episode.draft?
          format.html { redirect_to draft_path, notice: 'Episode draft was successfully updated.' }
        else
          format.html { redirect_to @episode, notice: 'Episode was successfully published.' }
        end
        format.json { render :show, status: :ok, location: @episode }
      else
        format.html { render :edit }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.json
  def destroy
    @episode.destroy
    respond_to do |format|
      format.html { redirect_to episodes_url, notice: 'Episode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_episode
      logger.debug ">>>>>>> beginnging of set_episode. @episode is: #{@episode}"
      if /\A\d+\z/.match(params[:slug_or_number])               # does the incoming URL param contain an integer?
        @episode = Episode.find_by number: params[:slug_or_number] # if so, look up the requested episode by its number
        logger.debug ">>>>>>> set_episode got a :slug_or_number, and it is a number. Setting @episode."
      elsif /\A[\w-]+\z/.match(params[:slug_or_number])            # is the param alphanumeric, potentially with dashes?
        @episode = Episode.find_by slug: params[:slug_or_number]   # if so, look up the requested episode by its slug
        logger.debug ">>>>>>> set_episode got a :slug_or_number, and it is a slug. Setting @episode."
      else
        redirect_to episode_path                                   # look, I agree it's unlikely someone is gonna try and cram symbols into the URL but let's not take chances.
      end
    end

    def set_draft
    # Used when a form is submitted to update the episode.draft attribute depending on which button was selected.
      if params[:commit] == 'Save as draft'
        @episode.draft = true
      elsif params[:commit] == 'Publish'
        @episode.draft = false
      end
    end

    def create_photo_objects
    # When images are uploaded, we need to create new Image objects, attach the files, and associate the Image with this @episode
      for image in (params.require(:episode).permit(images: [])[:images] || []) do
        @image = @episode.images.create().image.attach(image)
      end
    end

    def update_photo_captions
    # When we save @episode, we also want to update the captions of the associated Images.
      for image_id, image_caption in (params[:image_captions] || []) do
        if params[:remove_image]  # Don't update captions if we're about to delete the photo.
          to_be_deleted = params[:remove_image].include? image_id
        end
        if not to_be_deleted      # TODO: can these two ifs be refactored together?
          Image.find_by(id: image_id).update(caption: image_caption)
        end
      end
    end

    def delete_photo_objects
    # When the user checks image deletion checkboxes, we need to go through and delete those Image objects.
      for image_id in (params[:remove_image] || []) do
        Image.find_by( id: image_id).destroy!
      end
    end

    def delete_audio_attachment
    # When the user checks the audio remove checkbox, we need to purge that attached file.
      if params.has_key? :remove_audio
        @episode.audio.purge
      end
    end

    def episode_params
    # Whitelist params before pushing them into the database. Update slug when needed.
      proposed_params = params.require(:episode).permit(:commit, :number, :title, :slug, :publish_date, :description, :notes, :audio)
      if proposed_params[:title].empty? and proposed_params[:slug].empty?
        # If the user hasn't specified a title, we still need a slug to reference, so use a placeholder.
        proposed_params[:slug] = 'untitled-draft'
      elsif proposed_params[:slug].empty? or (proposed_params[:slug] == 'untitled-draft' and not proposed_params[:title].empty?)
        # If the user has previously not specified a title, but has now updated it and not touched the slug, update it now.
        proposed_params[:slug] = Episode.slugify(proposed_params[:title])
      end
      proposed_params
    end

    # def build_slug
    # # Before saving an episode, we need to make sure the slug is valid, and assign one if it isn't.
    #   byebug
    #   if @episode.title.empty?
    #     @episode.slug = 'untilted-draft'
    #   elsif not defined? @episode.slug || @episode.slug.empty?
    #     @episode.slug = Episode.slugify(@episode.title)
    #     logger.debug ">>>>>>> empty slug field. Is now: #{@episode.slug}"
    #   elsif @episode.slug == 'untilted-draft' and not @episode.title.empty?
    #     @episode.slug = Episode.slugify(@episode.title)
    #   end
    # end
end
