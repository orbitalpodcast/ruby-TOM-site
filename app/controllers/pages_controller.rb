class PagesController < ApplicationController

    def index
      if admin_signed_in?
        if Delayed::Job.exists?
          @scheduled_jobs = Delayed::Job.all
        end
        if Episode.draft_waiting?
          @drafts = Episode.not_published
        end
      end
      @episodes = Episode.most_recent_published(Settings.views.number_of_homepage_episodes) || []
    end
end