class AddRedditUrlToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :reddit_url, :string
  end
end
