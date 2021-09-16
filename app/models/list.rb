class List < ApplicationRecord
  belongs_to :user


  validates :name, presence: true, length: { maximum: 250 }
end
