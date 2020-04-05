require 'active_record/fixtures'

ActiveRecord::FixtureSet.create_fixtures("#{Rails.root}/test/fixtures", "episodes")

ActiveRecord::FixtureSet.create_fixtures("#{Rails.root}/test/fixtures", "users")

ActiveRecord::FixtureSet.create_fixtures("#{Rails.root}/test/fixtures", "admins")

ActiveRecord::FixtureSet.create_fixtures("#{Rails.root}/test/fixtures", "products")
