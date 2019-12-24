class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :caption
      t.belongs_to :episode

      t.timestamps
    end
  end
end
