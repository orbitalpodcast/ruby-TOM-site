class EpisodesController < ApplicationController
  skip_before_action :authorized,         only: [:index, :show] # allow not logged in users to access index and show.
  before_action :set_episode,             except: [:index, :draft] # allow URL to reference slug or episode number
  before_action :handle_submit_button,    only: :update
  after_action  :create_photo_objects,
                :update_photo_captions, 
                :delete_photo_objects,
                :delete_audio_attachment, only: [:create, :update]

  # GET /episodes
  # GET /episodes.json
  # GET /episodes.rss
  def index
    # Determine the appropriate range of episodes
    ep_range = []
    first_ep_num = Episode.published.first.number # Episode 1
    last_ep_num  = Episode.published.last.number  # Episode 250 or whatever
    unless params.has_key?(:begin) and params.has_key?(:end)
      # set ep_range if /episodes was called, or /to/ was malformed
      ep_range = [last_ep_num, last_ep_num - Settings.views.number_of_episodes_per_page + 1]
    else
      [params[:end], params[:begin]].each do |param|
        param = first_ep_num if param == 'first'
        param = last_ep_num  if param == 'last'
        ep_range << param
      end
    end
    ep_range.map! { |e| e.to_i} # sort can take strings or numbers, but they can't be mixed.
    ep_range.sort!

    # Pass selected episodes to views
    @episodes = Episode.published.where( number: (ep_range[0]..ep_range[1]) ).reverse
    @rss_episodes = Episode.published.reverse # TODO build RSS tests. github.com/edgar/feedvalidator

    # Figure out what other ranges to link to, for pagination
    current_range_distance = ep_range[1] - ep_range[0]
    # move to higher number episodes (more recent)
    @previous_page_start = [ep_range[1] + 1 + current_range_distance, last_ep_num].min
    @previous_page_end   = @previous_page_start - current_range_distance
    if @previous_page_start == ep_range[1]
      @previous_page_start = nil
    end
    # move to lower number episodes (older)
    @next_page_end   = [ep_range[0] - 1 - current_range_distance, first_ep_num].max
    @next_page_start = @next_page_end + current_range_distance
    if @next_page_end == ep_range[0]
      @next_page_end = nil
    end

    respond_to do |format|
      format.html
      format.rss { render :layout => false }
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
  end

  # GET /draft
  def draft
    # Redirects to edit or acts as new
    if Episode.draft_waiting?
      @episode = Episode.not_published.last
      redirect_to edit_episode_path @episode
    else
      @episode = Episode.new
      @episode.number = (Episode.maximum('number') || 0) + 1
      @episode.publish_date = DateTime.parse('tuesday') + (DateTime.parse('tuesday') > DateTime.current ? 0:7) # find next tuesday TODO: pull publish date/schedule out into config file
      @episode.draft = true
      @episode.newsletter_status = 'not scheduled'
      render :new
    end
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.new(episode_params)
    @episode.slug = build_slug episode_title: episode_params[:title], episode_slug: episode_params[:slug]
    if @episode.save
      # We never publish episodes from create, so we want to redirect to edit, not to show.
      redirect_to edit_episode_path(@episode), notice: 'Episode draft was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    @episode.slug = build_slug episode_title: episode_params[:title], episode_slug: episode_params[:slug]
    respond_to do |format|
      if @episode.update( episode_params.merge!(slug:              @episode.slug,
                                                draft:             @episode.draft,
                                                newsletter_status: @episode.newsletter_status
                                                ).except(:images))
        handle_newsletter
        update_notice = publish # returns a string, indicating if publish tasks were completed.
        format.html { redirect_to edit_episode_path(@episode), notice: update_notice }
      else
        @episode.update_attribute(:newsletter_status, 'not scheduled') if @episode.newsletter_status == 'scheduling'
        @episode.reload # discards all user changes. Worth only resetting draft and newsletter_status?
        format.html { render :edit }
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

    def handle_submit_button
      # Before_action. Multiple submit buttons can be clicked. Each one expects a different behavior.
      if ['Save as draft', 'Revert to draft'].include? params[:commit]
        logger.debug ">>>>>>> #{params[:commit]} clicked"
        @episode.draft = true
      elsif ['Draft and schedule newsletter'].include? params[:commit]
        logger.debug ">>>>>>> #{params[:commit]} clicked"
        @episode.draft = true
        @episode.newsletter_status = 'scheduling'
      elsif ['Cancel scheduled newsletter'].include? params[:commit]
        logger.debug ">>>>>>> #{params[:commit]} clicked"
        @episode.newsletter_status = 'canceling'
      elsif ['Publish', 'Publish changes'].include? params[:commit]
        logger.debug ">>>>>>> #{params[:commit]} clicked"
        @episode.draft = false
      else
        logger.debug ">>>>>>> No commit matched. params-commit: #{params[:commit]}"
      end
    end
    
    def handle_newsletter
      # Called on successful updates. Picks up where handle_submit_button leaves off. Called after successful save (so
      # that validations are run, and the emailer has good data), so we also modify the database with the new status.
      if @episode.newsletter_status == 'scheduling'
        schedule_newsletter
        @episode.update_attribute :newsletter_status, 'scheduled'
      elsif @episode.newsletter_status == 'canceling'
        unschedule_newsletter
        @episode.update_attribute :newsletter_status, 'not scheduled'
      end
    end

    def schedule_newsletter
      # TODO: detect and handle scheduling a newsletter when the time has already passed. Warn then send immediately?
      # TODO: change newsletter_job_id from a saved number to an activerecord association?
      email_time = Time.parse Settings.newsletter.default_send_time
      email_datetime = DateTime.new(@episode.publish_date.year, @episode.publish_date.month, @episode.publish_date.day,
                                    email_time.hour, email_time.min, email_time.sec, email_time.zone)
      logger.debug ">>>>>>> Scheduling newsletter for #{email_datetime}"

      scheduled_job = EpisodeMailer.delay(run_at: email_time).show_notes(@episode)
      @episode.update_attribute :newsletter_job_id, scheduled_job.id
    end

    def unschedule_newsletter
      logger.debug ">>>>>>> Deleting scheduled job #{@episode.newsletter_job_id}"
      Delayed::Job.find(@episode.newsletter_job_id).destroy!
    end

    def publish
      # Called on successful updates, and runs extra publication tasks if this isn't a draft.
      # Returns a string for the flash message.
      unless @episode.draft?
        logger.debug ">>>>>>> Publishing the episode."
        unless @episode.ever_been_published? # Some things should not happen if an episode was pulled down in an emergency.
          logger.debug ">>>>>>> #TWITTER: {@episode.description} #{episode_url(@episode)}"
          # TWITTER_CLIENT.update "#{@episode.description} #{episode_url(@episode)}"
        else
          logger.debug ">>>>>>> Not tweeting because the episode has been published previously."
        end
        # publish is called after validations were run, so we can safely update_attribute
        @episode.update_attribute :ever_been_published, true
        return 'Episode was successfully published.'
      end
      'Episode draft was successfully updated.'
    end

    def set_episode
      @episode = Episode.find_by(slug: params[:id]) || Episode.find_by(number: params[:id])
      # TODO: set_episode results in two database calls when given a number. Worth checking params presence first?
    end

    def build_slug(episode_title:, episode_slug:)
      # Try and replace an empty slug or a placeholder.
      if episode_slug.empty? || episode_slug == 'untitled-draft'
        if episode_title.empty?
          return 'untitled-draft'
        else
          return Episode.slugify(episode_title)
        end
      end
      # If the slug isn't empty or a placeholder, no need to replace it.
      return episode_slug
    end

    def create_photo_objects
      # When images are uploaded, we need to create new Image objects, attach the files, and associate the Image with this @episode
      for image in (episode_params[:images] || []) do
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
      params.require(:episode).permit(:commit, :number, :title, :slug, :publish_date, :description,
                                                        :notes, :audio, :draft, :newsletter_status, images: [])
    end
end
