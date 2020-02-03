class Episode < ApplicationRecord

  has_many :images, dependent: :destroy
  has_one_attached :audio
  default_scope { order(number: :asc) }
  scope :published,     -> {where draft: false}
  scope :not_published, -> {where draft: true}

  NEWSLETTER_STATUSES =  ['not scheduled',  # when newly created, and not ready to email
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
                            inclusion: { in: NEWSLETTER_STATUSES }
  # Validations before schduling an episode newsletter
  with_options if: -> { self.newsletter_status and self.newsletter_status_at_least? 'scheduling' } do |e|
    e.validates :title,
                              presence: true,
                              uniqueness: { case_sensitive: false },
                              length: { minimum: 5 }
                              # (Episode [0-9]{3}: )(DOWNLINK--|DATA RELAY--)?[\w\s]*
    e.validates :publish_date,
                :description,
                :notes,
                              presence: true
    e.validates :slug,
                              exclusion: { in: ['untitled-draft'] }
  end
  # Validations before publishing an episode
  with_options if: -> { not self.draft? } do |e|
      e.validate :scheduled_newsletter, on: :update
  end

  def scheduled_newsletter
    unless self.newsletter_status_at_least? 'scheduled'
      error = "Can't publish if the newsletter hasn't been handled. "
      error << "Hint: either schedule the newsletter, or confirm it won't be sent. "
      error << "After that, additional validations will be run and might generate new errors."
      self.errors[:base] << error
    end
  end

  #OVERRIDERS
  def to_param
    # Overrides default behavior, and constructs episode_path by using the slug.
    slug
  end

  # HANDY
  def publish_date_short
    self.publish_date.strftime Settings.views.date_format
  end
  def newsletter_status_at_least?(target_status)
    # Check progression of newsletter status through the expected stages.
    NEWSLETTER_STATUSES.find_index(target_status) <= NEWSLETTER_STATUSES.find_index(self.newsletter_status)
  end
  def newsletter_status_before?(target_status)
    # Check progression of newsletter status through the expected stages.
    NEWSLETTER_STATUSES.find_index(target_status) > NEWSLETTER_STATUSES.find_index(self.newsletter_status)
  end
  def self.draft_waiting?
    # Used by routes to determine where to send GET /draft
    where(draft: true).length > 0 # only accesses activerecord relation, so lazy loads
  end
  def self.most_recent_published(number_of_posts)
    # Get X number of most recent posts, presented newest first. Used on the index.
    published.last(number_of_posts).reverse # eager loads the objects
  end
  def self.slugify(unslug)
    # Drop all non-alphanumeric characters, and change spaces to hyphens
    unslug.to_str.downcase.gsub(/^(downlink|data relay)--(dr. )?/, '').gsub(/[^a-z0-9]/, ' '=>'-')
  end
  def next_episode()
    Episode.find_by number: self.number+1
  end
  def previous_episode()
    Episode.find_by number: self.number-1
  end
  def notes_as_html()
    # Make markup conversion available to Episode objects
    Episode.convert_markup_to_HTML(self.notes)
  end
  def full_title()
    "Episode #{self.number}: #{self.title}"
  end
  def self.full_title(number, title)
    "Episode #{number}: #{title}"
  end

  # MARKUP PARSER
  END_URL_REGEX =  /(?<esc>\/\/\/)?                # set optional escapement named group
                    (?<opar>\([[:blank:]]*)?       # look for leading open parens and padding spaces
                    (?<ht>HT.*:\ )?                # set optional hat tip named group. Escaped space BC free spacing
                    (?<protocol>                   # set optionaal protocol named group
                      (?:(http|https)\:\/\/)?
                      (?:www\.)?)
                    (?<domain>                     # set domain named group
                      (?:[\w-]+)                   # starts with a word group
                      (?:\.[\w-]+)+)               # following groups are separated by dots
                    (?<path>                       # set path named group
                      [\w.,@?^=%&;:\/~+#\(\)-]*    # lots of characters allowed here, including parens
                    (?(<opar>)                     # if-then statement to handle close paren
                      [\w@?^=%&;\/~+#*?\)-]        # if opar, match the final path character then...
                      (?=[[:blank:]]*\))           # ... lookahead for those optional spaces and a close paren.
                      |[\w@?^=%&;\/~+#?\h*?\)-]))? # if no opar, just match the last path character
                    (?<cpar>                       # set optional close paren named group
                      (?(<opar>)[[:blank:]]*\)?))  # actually match that cparen.
                   $/ix                            # match end of the line, be case insensitive, and allow free spacing

  def self.convert_markup_to_HTML(markup)
    lines = markup.split(/\n/)
    lines.map! {|l| l.rstrip} # split into lines and remove ending whitespace
    output = []
    previous_indent = 0 # used by SET BULLET INDENTS. We need to pass the previous bullet level to the next loop, or otherwise calculate it inside the loop, which would require a lot of backtracking to previous output lines.
    lines.each_with_index do |line, i|
      # FORMAT END URLS
      end_urls = []
      while end_url = line.match(END_URL_REGEX) do
        url_path = end_url[:path].presence || '' # Path needs to be optional here and when referenced later.
        url_match = ( end_url[:protocol].presence || "http://" ) + end_url[:domain] + url_path # Protocol needs to be optional!
        # Build HTML for end URLs. Handle special cases where formatting should be slightly different.
        if end_url[:esc]
          # ESCAPED FULL URLS
          construction = "<a href=\"#{url_match}\">#{url_match}</a>)"
        elsif end_url[:domain].match? /^(twitter\.com)|(instagram\.com)/i
          # USERNAMES AFTER DOMAIN
          construction = "<a href=\"#{url_match}\">#{end_url[:domain]}#{url_path[/^\/[^\/]+/i]}</a>)"
        elsif end_url[:domain].match? /reddit\.com/i
          # USERNAMES AFTER DOMAIN WITH IDENTIFIER
          # TODO: generalize convert_markup_to_HTML to include all usernames after domain, but with things in the middle, like /r/ and /u/ 
          construction = "<a href=\"#{url_match}\">#{url_path.match(/\/r\/[^\/]+/i)}</a>)"
        elsif url_path.match? /\.pdf\/?$/i
          # PDF
          construction = "PDF: <a href=\"#{url_match}\">#{end_url[:domain]}</a>)"
        else
          # ALL ELSE
          construction = "<a href=\"#{url_match}\">#{end_url[:domain]}</a>)"
        end
        # Finish building HTML. Handle hat tips
        if end_url[:ht] # TODO: in markup_to_html, instead of adding parens while deciding on HTs, is it better to add parens in construction and insert the HT after?
          construction.prepend " (#{end_url[:ht]}"
        else
          construction.prepend " ("
        end
        end_urls.unshift construction   # add output to FRONT of end_urls because we're working from the end of the line forwards
        line.chomp!(end_url[0]).rstrip! # removed our processed end_url from the line, then loop again
      end
      line = line.concat(*end_urls).lstrip unless end_urls.empty? # If the line contained a URL and nothing else, it'll still have a leading space.
      
      # SET SECTION HEADERS
      for header in Settings.markup.headers.each do
        # TODO in markup settings, check if *** wildcard works anywhere other than the end of a line.
        # TODO in convert_markup_to_html, add functionality to handle settings.header_symbol
        if line.strip =~ Regexp.new("^[[:blank:]]*" + Settings.markup.header_symbol + "[[:blank:]]*(?<header>.*)$")
          correct_header = $~[1].strip
          line = "<h3>#{correct_header}</h3>"
          break
        elsif line.strip =~ Regexp.new( header[0].to_s.gsub(/\*\*\*/, '([[:ascii:]]*)'), true) # allow wildcards and case insensitivity
          correct_header = header[1] || header[0]
          correct_header = correct_header.to_s
          wildcard_content = $~[1] || ''
          correct_header.gsub!(/\*\*\*/, wildcard_content)
          line = "<h3>#{correct_header}</h3>"
          break
        end
      end

      # SET BULLET INDENTS
      indent_level = 0
      indent_level += 1 while line.gsub! /^ *\*/, '' # count up and chomp off leading asterisks, ignoring spaces
      line.strip! # presumably the line will have a space between the bullet asterisks and the text.
      if indent_level > 0
        next_indent = 0
        if next_line = lines[i+1].dup # if we're on the last line, line+1.dupe will return nil and we won't change the value of next_indent 
          next_indent += 1 while next_line.gsub! /^ *\*/, '' # We might have consecutive *s elsewhere in the string, so better to gsub than scan.
        end 
        open_ul  = (indent_level - previous_indent).clamp 0,10  # TODO can convert_markup_to_html > set bullets safely only increase indent by one from line to line?
        close_ul = (indent_level - next_indent    ).clamp 0,10
        line = "#{"<ul>"*open_ul}<li>#{line}</li>#{"</ul>"*close_ul}"
      end
      previous_indent = indent_level
      
      # SET BOLD AND ITALLICS
      # This is specifically done after setting bullets, so that we get rid of pesky leading asterisks
      # TODO: markup: fix nested issue in ep 233
      if line =~ /\*\*.*\*\*/
        line.gsub! /\*\*.*\*\*/, "<strong>#{$~[0][2..-3]}</strong>" # Here, $~ actually pulls the match from the =~ above. Can we DRY the regex?
      end
      if line =~ /\*.*\*/
        line.gsub! /\*.*\*/, "<i>#{$~[0][1..-2]}</i>"
      end

      # ADD FINISHED LINE TO OUTPUT
      output << line + "\n"
    end
    output.join.rstrip!
  end

end