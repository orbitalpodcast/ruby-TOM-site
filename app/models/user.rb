class User < ApplicationRecord
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  \z/

  EMAIL_FORMAT = /\A
    [A-Za-z0-9._%+-]+ # User is alphanumerics, as well as some special characters
    @                 # an @ separates user and domain
    [A-Za-z0-9.-]+    # domain name includes alphanumerics and some special characters
    \.[A-Za-z]{2,}    # TLD begins with a dot and has at least two alphas
  \z/

  has_secure_token :access_token
  has_secure_password validations: false # default validations are crap anyway. Skip and allow non-admins to not have a password.

  validates :email,
                    presence: true,
                    uniqueness: {message: "Looks like you've already signed up with that address. "\
                                           "There's an unsubscribe link at the bottom of each of "\
                                           "our emails, if that's what you're trying to do."},
                    format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/ }
  validates :admin,
                    inclusion: { in: [true, nil] }
  validates :password, 
                      presence: true,  
                      format: { with: PASSWORD_FORMAT },
                      if: -> { self.admin? }

  def to_param
    access_token
  end

  def self.all_admins
    where(admin: true)
  end

  def self.all_non_admins
    where(admin: nil)
  end

  def self.all_subscribed
    where(subscribed: true)
  end

end
