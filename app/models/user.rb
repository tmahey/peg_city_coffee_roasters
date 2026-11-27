class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  validates :name, presence: true
  validates :address, length: { maximum: 200 }, allow_blank: true
  validates :city, length: { maximum: 80 }, allow_blank: true
  validates :postal_code,
            format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
                      message: "must be a valid Canadian postal code" },
            allow_blank: true

  def address_complete?
    address.present? && city.present? && postal_code.present? && province.present?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[address city created_at email id name postal_code province_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[orders province]
  end
end
