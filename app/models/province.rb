class Province < ApplicationRecord
  has_many :customers, dependent: :nullify
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true, uniqueness: { case_sensitive: false },
                   length: { is: 2 }, format: { with: /\A[A-Z]{2}\z/, message: "must be 2 uppercase letters" }
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[code gst_rate hst_rate id name pst_rate]
  end
end
