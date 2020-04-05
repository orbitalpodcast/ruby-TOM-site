class OrdersProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product
  # TODO: ordersproduct doesn't seem to correctly validate quantity max
  validates_presence_of :quantity, numericality: { only_integer: true,
                                                   less_than: 10}
  after_save { |op| op.destroy if op.quantity <= 0 }
end
