class Episode < ApplicationRecord
  # has_many :photos

  validates :number,
                            presence: true,
                            uniqueness: true,
                            numericality: {only_integer: true, greater_than: 0}
  validates :slug,  # TODO: validate self.slugify-style regex
                            presence: true,
                            uniqueness: true,
                            length: { minimum: 1 }
  validates :draft,
                            inclusion: { in: [true, false] }
  validates :title,
                            presence: true,
                            uniqueness: true,
                            length: { minimum: 1 },
                            on: :publish
  validates :publish_date,
            :description,
            :notes,
                            presence: true,
                            on: :publish

  def to_param                                    # Overrides default behavior, and constructs episode_path by using the slug.
    slug
  end
  def self.most_recent_draft                      # Mostly used by episodes#set_episode when :slug_or_number.blank?
    where(draft: true).limit(1)
  end
  def self.draft_waiting?                         # Used by routes to determine where to send GET /draft
    where(draft: true).length > 0
  end
  def self.most_recent_published(number_of_posts) # Get X number of most recent posts. Used on the index.
    where(draft: false).order(publish_date: :desc).limit(number_of_posts)
  end
  def self.slugify(unslug)                        # Drop all non-alphanumeric characters, and change spaces to hyphens
    unslug.to_str.downcase.gsub(/[^a-z0-9]/, ' '=>'-')
  end

end