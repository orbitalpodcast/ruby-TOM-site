class PagesController < ApplicationController
  skip_before_action :authorized

    def index
      if logged_in_admin? and Delayed::Job.exists?
        @scheduled_jobs = Delayed::Job.all
      end
      if logged_in_admin? and Episode.draft_waiting?
        @drafts = Episode.not_published
      end
      @episodes = Episode.most_recent_published(Settings.views.number_of_homepage_episodes) || []
    end
end