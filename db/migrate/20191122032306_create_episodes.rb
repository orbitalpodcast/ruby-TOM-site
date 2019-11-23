class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.boolean :draft
      t.integer :number, index: {unique: true}
      t.string  :title
      t.string  :slug, index: {unique: true}
      t.date    :publish_date
      t.string  :description
      t.string  :notes

      t.timestamps
    end
  end
end
