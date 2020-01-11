class ApplicationMailer < ActionMailer::Base
  default from: Settings.newsletter.from
  layout 'mailer'
end
