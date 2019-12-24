class Image < ApplicationRecord
  belongs_to :episode
  has_one_attached :image
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }
end
