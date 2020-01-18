class Episode < ApplicationRecord
  
  has_many :images, dependent: :destroy
  has_one_attached :audio

  NEWESLETTER_STATUSES =  ['not scheduled',  # when newly created, and not ready to email
                           'scheduling',     # when scheduling requested, but not completed
                           'canceling',      # when canceling a scheduled send requested, but not completed
                           'scheduled',      # when notes are done, and an email is scheduled
                           'sent',           # when email has been sent
                           'not sent']       # rare: when no email has or will be sent

# Validations for all episodes
  validates :number,
                            presence: true,
                            uniqueness: true,
                            numericality: {only_integer: true, greater_than: 0}
  validates :slug,  # TODO: validate episode slug conforms to slugify regex
                            presence: true,
                            uniqueness: true,
                            length: { minimum: 5 }
  validates :draft,
                            inclusion: { in: [true, false] }
  validates :newsletter_status,
                            inclusion: { in: NEWESLETTER_STATUSES }
# Validations before schduling an episode newsletter
  with_options if: -> { self.newsletter_status and self.newsletter_status_at_least 'scheduling' } do |e|
    e.validates :title,
                              presence: true,
                              uniqueness: { case_sensitive: false },
                              length: { minimum: 5 }
                              # (Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--){0,1}[\w\s]*
    e.validates :publish_date,
                :description,
                :notes,
                              presence: true
    e.validates :slug,
                              exclusion: { in: ['untitled-draft'] }
  end
# Validations before publishing an episode
  with_options if: -> { not self.draft? } do |e|
  end


  def to_param
  # Overrides default behavior, and constructs episode_path by using the slug.
    slug
  end
  def newsletter_status_at_least(target_status)
  # Check progression of newsletter status through the expected stages.
    NEWESLETTER_STATUSES.find_index(target_status) <= NEWESLETTER_STATUSES.find_index(self.newsletter_status)
  end
  def newsletter_status_before(target_status)
  # Check progression of newsletter status through the expected stages.
    NEWESLETTER_STATUSES.find_index(target_status) > NEWESLETTER_STATUSES.find_index(self.newsletter_status)
  end
  def self.most_recent_draft
  # Mostly used by episodes#set_episode when :slug_or_number.blank?
    where(draft: true).limit(1)
  end
  def self.draft_waiting?
  # Used by routes to determine where to send GET /draft
    where(draft: true).length > 0
  end
  def self.most_recent_published(number_of_posts)
  # Get X number of most recent posts. Used on the index.
    where(draft: false).order(publish_date: :desc).limit(number_of_posts)
  end
  def self.slugify(unslug)
  # Drop all non-alphanumeric characters, and change spaces to hyphens
    unslug.to_str.downcase.gsub(/[^a-z0-9]/, ' '=>'-')
  end
end
