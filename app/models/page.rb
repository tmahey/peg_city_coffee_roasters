class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, inclusion: { in: %w[about contact] }
  validates :content, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[content created_at id slug title updated_at]
  end
end
