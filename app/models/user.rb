class User < ApplicationRecord

  has_secure_token :access_token

  validates :email,
                    presence: true,
                    uniqueness: true
  validates :admin,
                    inclusion: { in: [true, false] }

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password, 
                      presence: true,  
                      format: { with: PASSWORD_FORMAT },
                      if: -> { self.admin? }

end
