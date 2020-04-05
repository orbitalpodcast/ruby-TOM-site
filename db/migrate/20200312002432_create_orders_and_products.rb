class CreateOrdersAndProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :description
      t.integer :status
      t.integer :stock_quantity
      t.integer :price_cents
      t.integer :ship_cost_domestic_cents
      t.integer :ship_cost_international_cents

      t.timestamps
    end

    create_table :orders do |t|
      t.belongs_to :user

      t.integer :subtotal_cents
      t.integer :ship_cents
      t.integer :total_cents
      t.integer :status,          default: 0
      t.string  :token,           index: true
      t.string  :charge_id
      t.string  :error_message
      t.string  :customer_id
      t.integer :payment_gateway, default: 0
      t.text    :links

      t.timestamps
    end

    create_table :orders_products do |t|
      t.integer :quantity, null: false, default: 1

      t.belongs_to :product
      t.belongs_to :order
    end
  end
end
