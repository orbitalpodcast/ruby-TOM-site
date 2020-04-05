class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :full_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postcode
      t.string :country
      t.timestamps

      t.references :addressable, polymorphic: true, index: true
    end
  end
end
