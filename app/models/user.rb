class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :lockable, :confirmable, :timeoutable
  enum account_type: [:no_login,             # newsletter, guest customers, and TWSF only
                      :payment_only,         # supporters can log in
                      :payment_and_shipping] # store customers can log in
  before_create {self.quick_unsubscribe_token = Devise.friendly_token}

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

  # validates :email,
  #                   presence: true,
  #                   uniqueness: {message: "Looks like you've already signed up with that address. "\
  #                                          "There's an unsubscribe link at the bottom of each of "\
  #                                          "our emails, if that's what you're trying to do."},
  #                   format: { with: EMAIL_FORMAT }
  # validates :password, 
  #                     if: -> { customer_data? },
  #                     presence: true,  
  #                     format: { with: PASSWORD_FORMAT }

  def self.all_subscribed
    where(subscribed: true)
  end

  def active_for_authentication?
    super && !self.no_login?
  end

  protected
  
  # DEVISE TWEAKS
  def password_required?
    return false if self.no_login?
    super
  end

  # def email_required?
  #   true if user.just_TWSF_tracking
  # end

end
