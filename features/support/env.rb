# Generated by cucumber-sinatra. (2011-06-22 04:43:43 -0400)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'tennis.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = Tennis

class TennisWorld
  include Capybara
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  TennisWorld.new
end