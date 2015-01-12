ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler/setup'
require 'up_and_at_them'

RSpec.configure do |config|
  config.order = :random
end
