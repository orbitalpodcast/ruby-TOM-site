class Episode < ApplicationRecord
  # has_many :photos

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
