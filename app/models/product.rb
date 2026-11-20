class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :search_by_keyword, lambda { |keyword|
    return all if keyword.blank?

    term = "%#{sanitize_sql_like(keyword.strip)}%"
    where("title LIKE :term OR description LIKE :term", term: term)
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at description id price stock_quantity title updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end
end
