source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use sqlite3 as the database for Active Record
gem 'pg', '~> 1.2.2'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# TODO: consider using protected_attributes gem

# Activate Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use Devise for user model
gem 'devise', '~>4.7.1'

# Use DJ as a queuing backend
gem 'delayed_job_active_record', '~> 4.1.4'

# Twitter API
gem 'twitter', '~>6.2.0'

# Reddit API
gem 'reddit_bot', "~>1.7.4"

# Paypal API
gem 'paypal-checkout-sdk', "~>1.0"

# Use activestorage-audio to interpret mp3 tags. Requires ffmpeg to be installed, locally and on server.
# heroku buildpacks:add https://github.com/FFmpeg/FFmpeg.git
# Adding multiple buildpacks also requires Procfile to be included. The default won't work.
gem 'activestorage-audio', '~>0.1.0'

# Use Active Storage variant. Requires imagemagick to be installed, locally and on server. Heroku auto-installs.
gem 'image_processing', '~> 1.12'

# Use plyr as an in-line audio player. Maybe later video headers too?
gem 'plyr-rails', '~>3.4.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'config'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  # Preview email in the default browser instead of sending it.
  gem "letter_opener"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # add support for assigns
  gem 'rails-controller-testing'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
