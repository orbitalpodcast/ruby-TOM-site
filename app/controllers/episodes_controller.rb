class EpisodesController < ApplicationController
  before_action :build_slug,  only: [:show, :edit, :update, :destroy]
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

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
  def new
    @episode = Episode.new
    @episode.title = 'enter your title here'
    @episode.number = Episode.maximum('number') + 1
  end

  # GET /episodes/1/edit
  def edit
  end

  # POST /episodes
  # POST /episodes.json
  def create
    # logger.debug ">>>>>>>create was invoked"

    @episode = Episode.new(episode_params)

    set_draft
    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode, notice: 'Episode was successfully created.' }
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
    # logger.debug ">>>>>>>update was invoked"

    set_draft
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
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
      if /\A\d+\z/.match(params[:slug_or_number])                  # does the incoming URL param contain a number?
        @episode = Episode.find_by number: params[:slug_or_number] # if so, look up the requested episode by its number
      else
        @episode = Episode.find_by slug: params[:slug_or_number]   # if not, look up the requested episode by its slug
      end
    end

    def set_draft
      if params[:commit] == 'Save as draft'
        @episode.draft = true
        logger.debug ">>>>>>>draft was clicked"
      elsif params[:commit] == 'Publish'
        @episode.draft = false
        logger.debug ">>>>>>>publish was clicked"
      end
    end

    def build_slug
      if defined? @episode.slug
        # Drop all non-alphanumeric characters, and change spaces to hyphens
        @episode.slug = @episode.title.downcase.gsub(/[^a-z0-9]/, ' '=>'-')
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:draft, :number, :title, :slug, :publish_date, :description, :notes)
    end
end