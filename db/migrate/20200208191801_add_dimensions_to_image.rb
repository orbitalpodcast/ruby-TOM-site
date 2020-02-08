class AddDimensionsToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :dimensions, :string,  array: true
  end
end
