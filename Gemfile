# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

group :development do
  # Type checker
  gem 'sorbet'
end

group :test do
  # BDD tests
  gem 'rspec'
  # CodeCoverage
  gem 'simplecov', require: false
  # Documentation
  gem 'rdoc', require: false
  # Linter
  gem 'rubocop', '~> 0.72.0', require: false
  gem 'rubocop-performance'
end

gem 'sorbet-runtime'
