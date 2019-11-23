class Episode < ApplicationRecord
  # has_many :photos

  validates :number,            presence: true,
                                uniqueness: true,
                                numericality: {only_integer: true, greater_than: 0}
  validates :title,:slug,
                                presence: true,
                                uniqueness: true
  validates :publish_date,
            :description,:notes,
                                presence: true
  validates :draft,             inclusion: { in: [true, false] }

  def to_param
    slug
  end

  def self.published_episodes()
    where(draft: false)
  end
  def self.current_draft()
    find_by(draft: true)
  end
  def self.most_recent()
    Episodes.maximum('number')
  end

end
