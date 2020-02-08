class Image < ApplicationRecord
  belongs_to :episode
  has_one_attached :image
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  def get_dimensions
    if self.dimensions.nil? or self.dimensions.include? nil
      self.dimensions = [ self.image.metadata[:width], self.image.metadata[:height] ]
    end
    self.save if self.changed?
    self.dimensions
  end
end
