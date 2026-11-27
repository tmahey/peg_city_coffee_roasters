class Order < ApplicationRecord
  STATUSES = %w[pending paid shipped].freeze

  belongs_to :customer
  belongs_to :user, optional: true
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_taxes
    gst_amount + pst_amount + hst_amount
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at customer_id gst_amount hst_amount id province_id pst_amount status subtotal total_price user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer order_items products province user]
  end
end
