class Base < ApplicationRecord
  validates :base_number, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :base_name, presence: true, length: { maximum: 100 }
  validates :base_category, presence: true, length: { maximum: 100 }
end
