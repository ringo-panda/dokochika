class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :lists, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_many :list_spots, dependent: :destroy


  private

  #画像のファイル形式のバリデーション
  def image_type
    if !image.blob.content_type.in?(%('image/jpeg image/png'))
      errors.add(:image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end
end
