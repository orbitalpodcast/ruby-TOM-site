class Order < ApplicationRecord
  enum status: [:fresh, :payment_pending, :paid, :payment_failed, :fulfilled]
  enum payment_gateway: [:paypal]
  serialize :links, Hash
  scope :recently_created, -> { where(created_at: 1.minutes.ago..DateTime.now) }
  after_find :update_totals, if: :fresh?

  # RELATIONS
  belongs_to :user
  has_many :orders_products
  has_many :products, -> { select('products.*, orders_products.quantity as quantity')
                           .readonly(true) },
                      through: :orders_products
  accepts_nested_attributes_for :orders_products, allow_destroy: true
  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  # VALIDATIONS
  # TODO: add order validation for associated user
  # TODO: add order validation for attribute changes at different statuses
  # TODO: add order validation for final check before Paypal
  # TODO: add final confirmation page before sending to paypal???

  protected

  def update_totals
    prices = self.products.pluck :price_cents
    quantities = self.products.pluck :quantity
    self.subtotal_cents = prices.zip(quantities) # put prices and quantities together
                          .map{|x,y| x*y} # multiply prices and quantities
                          .inject(:+) # sum up
    if self.address.country == "US"
      self.ship_cents = products.pluck(:ship_cost_domestic_cents).sum
    else
      self.ship_cents = products.pluck(:ship_cost_international_cents).sum
    end
    self.total_cents = self.subtotal_cents + self.ship_cents
  end

end
