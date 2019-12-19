class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :edit, :update, :destroy] #allow URL to reference slug or episode number

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.all
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
    logger.debug ">>>>>>>create was invoked"

    @episode = Episode.new(episode_params)
    build_slug
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
    logger.debug ">>>>>>>update was invoked"

    build_slug
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
      if /\A\d+\z/.match(params[:slug_or_number])                  # does the incoming URL param contain an integer?
        @episode = Episode.find_by number: params[:slug_or_number] # if so, look up the requested episode by its number
        logger.debug ">>>>>>> setting @episode by params number"
      elsif /\A[\w-]+\z/.match(params[:slug_or_number])            # is the param alphanumeric, potentially with dashes?
        @episode = Episode.find_by slug: params[:slug_or_number]   # if so, look up the requested episode by its slug
        logger.debug ">>>>>>> setting @episode by params slug"
      else
        redirect_to episodes_path                                  # look, I agree it's unlikely someone is gonna try and cram symbols into the URL but let's not take chances.
      end
    end

    def set_draft                                                  # used when a form is submitted to update the episode.draft attribute depending on which button was selected.
      if params[:commit] == 'Save as draft'
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:draft, :number, :title, :slug, :publish_date, :description, :notes)
    end
end








