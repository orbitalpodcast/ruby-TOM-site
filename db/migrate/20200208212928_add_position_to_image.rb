class AddPositionToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :position, :integer
  end
end
