class AddTwitterUrlToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :twitter_url, :string
  end
end
