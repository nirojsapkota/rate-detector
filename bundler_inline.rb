# bundler to include required gems
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'csv', require: false
  gem 'rubocop', require: false
  gem 'byebug'

  group :test do
    gem 'rspec'
  end
end
puts 'Gems installed'
