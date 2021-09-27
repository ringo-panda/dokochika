class Spot < ApplicationRecord
  belongs_to :user
  has_many :list_spots, dependent: :destroy
  has_many :lists, through: :list_spots
  accepts_nested_attributes_for :list_spots, allow_destroy: true
end
