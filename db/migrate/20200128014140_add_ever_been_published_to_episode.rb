class AddEverBeenPublishedToEpisode < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :ever_been_published, :boolean
  end
end
