class AddSubscribedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :subscribed, :boolean
  end
end
