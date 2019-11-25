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

  def self.published()
    where(draft: false)
  end
  def self.drafts()
    where(draft: true)
  end
  def self.most_recent_published(number_of_posts)
    order(publish_date: :desc).limit(5)
  end
  def self.slugify(unslug) # Drop all non-alphanumeric characters, and change spaces to hyphens
    unslug.to_str.downcase.gsub(/[^a-z0-9]/, ' '=>'-')
  end

end
