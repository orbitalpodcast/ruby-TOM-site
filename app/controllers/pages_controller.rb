class PagesController < ApplicationController
  skip_before_action :authorized

    def index
      if logged_in? and Delayed::Job.exists?
        @scheduled_jobs = Delayed::Job.all
      end
      if logged_in? and Episode.draft_waiting?
        @drafts = Episode.not_published
      end
      @episodes = Episode.most_recent_published(Settings.homepage.number_of_episodes) || []
    end
end