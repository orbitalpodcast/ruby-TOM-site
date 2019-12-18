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
  def to_param                                    # Overrides default behavior, and constructs episode_path by using the slug.
    slug
  end

  def self.published()
    where(draft: false)
  end
  def self.draft_waiting?                         # Used by routes to determine where to send GET /draft
    where(draft: true).length > 0
  end
  def self.most_recent_published(number_of_posts)
    order(publish_date: :desc).limit(5)
  end
  def self.slugify(unslug)                        # Drop all non-alphanumeric characters, and change spaces to hyphens
    unslug.to_str.downcase.gsub(/[^a-z0-9]/, ' '=>'-')
  end

end