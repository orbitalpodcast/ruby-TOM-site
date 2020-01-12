class User < ApplicationRecord
  # TODO: generate errors for each failed password validation condition
  PASSWORD_FORMAT = /
    (?=.{8,})   # Must contain 8 or more characters
    (?=.*\d)    # Must contain a digit
    (?=.*[a-z]) # Must contain a lower case character
    (?=.*[A-Z]) # Must contain an upper case character
    (?=.*[\W_]) # Must contain a special character
  /x

  EMAIL_FORMAT = /\A
    [A-Za-z0-9._%+-]+ # User is alphanumerics, as well as some special characters
    @                 # an @ separates user and domain
    [A-Za-z0-9.-]+    # domain name includes alphanumerics and some special characters
    \.[A-Za-z]{2,}    # TLD begins with a dot and has at least two alphas
  \z/x

  has_secure_token :access_token
  has_secure_password validations: false # default validations are crap anyway. Skip and allow non-admins to not have a password.

  validates :email,
                    presence: true,
                    uniqueness: {message: "Looks like you've already signed up with that address. "\
                                           "There's an unsubscribe link at the bottom of each of "\
                                           "our emails, if that's what you're trying to do."},
                    format: { with: EMAIL_FORMAT }
  validates :admin,
                    inclusion: { in: [true, nil] }
  validates :password, 
                      if: -> { self.admin? },
                      presence: true,  
                      format: { with: PASSWORD_FORMAT }

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
