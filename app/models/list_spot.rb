class ListSpot < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  belongs_to :list

  validates :user_id, presence: true
  validates :spot_id, presence: true
  validates :list_id, presence: true
end
