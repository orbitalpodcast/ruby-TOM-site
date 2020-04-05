class Product < ActiveRecord::Base
  has_many :orders_products
  has_many :orders, through: :orders_products
  enum status: [ 'unlisted', 'listed' ]

  scope :not_for_sale,     -> { where(stock_quantity: 0).or(where(status: :unlisted)) }
  scope :for_sale,         -> { where.not(stock_quantity: 0).where(status: :listed) }
  scope :quantity,         -> { select("orders.*, orders_products.quantity") }

  private

# PICKUP: how to modify attributes in teh join table cleanly?
# OrdersProduct.where(order_id: 1, product_id: o.products.first.id).take.quantity
# OrdersProduct.where(order_id: 1, product_id: o.products.first.id).take.update(quantity: 2)

end
