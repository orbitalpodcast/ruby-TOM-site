class AddNewsletterStatusToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :newsletter_status, :string
  end
end
