source "https://rubygems.org"

ruby "3.2.0"

gem "rails", "~> 7.1.5", ">= 7.1.5.1"
gem "sprockets-rails"
gem "pg", "~> 1.5"  # ✅ PostgreSQL のみ
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "devise", "~> 4.9"

gem "gon"

gem "dotenv-rails", groups: [:development, :test]
gem "omniauth", "~> 1.9"
gem "omniauth-google-oauth2", "~> 0.8"
gem "google-api-client", "~> 0.53.0"
gem "signet", "~> 0.17.0"

gem 'mysql2', '>= 0.5.3', '< 0.6.0'