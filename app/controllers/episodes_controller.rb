class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :edit, :update, :destroy] #allow URL to reference slug or episode number
  after_action :create_photo_objects, :update_photo_captions, :delete_photo_objects, only: [:create, :update]

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
    logger.debug ">>>>>>> edit was invoked"
    if @episode.draft?
      redirect_to draft_path
    end
  end

  # GET /draft
  def draft
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
    logger.debug ">>>>>>> create was invoked"

    @episode = Episode.new(episode_params)
    set_draft
    respond_to do |format|
      if @episode.save
        format.html { redirect_to draft_path, notice: 'Episode was successfully created.' }
        format.json { render :show, status: :created, location: @episode }
      else
        format.html { render :new }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    logger.debug ">>>>>>> update was invoked"

    set_draft
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to draft_path, notice: 'Episode was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      if not defined?(params[:slug_or_number]) || params[:slug_or_number].empty?
        if not params[:slug].empty?
          logger.debug '>>>>>> set_episode got a slug. Setting @episode.'
          @episode = Episode.find_by( slug: params[:slug])
        elsif not params[:number].empty?
          logger.debug '>>>>>> set_episode got a number. Setting @episode.'
          @episode = Episode.find_by( number: params[:number])
        end
      elsif /\A\d+\z/.match(params[:slug_or_number])               # does the incoming URL param contain an integer?
        @episode = Episode.find_by number: params[:slug_or_number] # if so, look up the requested episode by its number
        logger.debug ">>>>>>> set_episode got a :slug_or_number, and it is a number. Setting @episode."
      elsif /\A[\w-]+\z/.match(params[:slug_or_number])            # is the param alphanumeric, potentially with dashes?
        @episode = Episode.find_by slug: params[:slug_or_number]   # if so, look up the requested episode by its slug
        logger.debug ">>>>>>> set_episode got a :slug_or_number, and it is a slug. Setting @episode."
      else
        redirect_to episodes_path                                  # look, I agree it's unlikely someone is gonna try and cram symbols into the URL but let's not take chances.
      end

    end

    def set_draft                                                  # used when a form is submitted to update the episode.draft attribute depending on which button was selected.
      if params[:commit] == 'Save as draft'
        @episode.draft = true
      elsif params[:commit] == 'Publish'
        @episode.draft = false
      end
      logger.debug ">>>>>>> set_draft invoked. @episode.draft = #{@episode.draft}"
    end

    def build_slug                                                   # Currently a mess. Before saving to the DB, we need to make sure the slug is valid, and assign one if it isn't.
      if @episode.title.empty?
        @episode.slug = 'untilted-draft'
      elsif not defined? @episode.slug || @episode.slug.empty?
        @episode.slug = Episode.slugify(@episode.title)
        logger.debug ">>>>>>> empty slug field. Is now: #{@episode.slug}"
      elsif @episode.slug == 'untilted-draft' and not @episode.title.empty?
        @episode.slug = Episode.slugify(@episode.title)
      end
    end

    def create_photo_objects
      for image in (params.require(:episode).permit(images: [])[:images] || []) do
        @image = @episode.images.create(caption: 'not implemented yet').image.attach(image)
      end
    end

    def update_photo_captions
      for image_id, image_caption in (params[:image_captions] || []) do
        Image.find_by(id: image_id).update(caption: image_caption)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      # proposed_params = 
      params.require(:episode).permit(:draft, :number, :title, :slug, :publish_date, :description, :notes, :audio)
      # if proposed_params[:title].empty? and proposed_params[:slug].empty?
      #   proposed_params[:slug] = 'untilted-draft'
      # elsif proposed_params[:slug].empty? or (proposed_params[:slug] == 'untilted-draft' and not proposed_params[:title].empty?)
      #   proposed_params[:slug] = Episode.slugify(proposed_params[:title])
      # else
      #   logger.debug ">>>>>>> OH CRAP! Episode_params managed to not know how to set slug."
      #   logger.debug ">>>>>>> proposed_params is #{proposed_params}"
      # end
      # proposed_params
    end
end








