class AddNewsletterJobIdToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :newsletter_job_id, :integer
  end
end
