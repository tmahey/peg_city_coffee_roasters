class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true,
                          format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
                                    message: "must be a valid Canadian postal code" }

  def self.ransackable_attributes(_auth_object = nil)
    %w[address city email id name postal_code province_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[orders province]
  end
end
