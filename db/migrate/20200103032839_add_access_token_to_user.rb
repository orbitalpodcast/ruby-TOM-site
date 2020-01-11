class AddAccessTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_token, :string
  end
end
