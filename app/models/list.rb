class List < ApplicationRecord
  belongs_to :user
  has_many :list_spots, dependent: :destroy
  has_many :spots, through: :list_spots

  validates :name, presence: true, length: { maximum: 250 }
end
