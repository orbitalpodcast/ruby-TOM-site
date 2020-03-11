class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :quick_unsubscribe_token, index: {unique: true}
      t.integer :account_type,            default: 0
      t.boolean :subscribed,              default: false

      t.timestamps null: false
    end
  end
end
