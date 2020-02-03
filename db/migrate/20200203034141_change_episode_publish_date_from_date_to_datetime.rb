class ChangeEpisodePublishDateFromDateToDatetime < ActiveRecord::Migration[6.0]
  def up
    change_column :episodes, :publish_date, :datetime
  end

  def down
    change_column :episodes, :publish_date, :date
  end
end
