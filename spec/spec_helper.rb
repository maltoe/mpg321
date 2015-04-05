require 'rubygems'
require 'bundler/setup'
require 'pry-byebug'


Dir['./spec/support/*.rb'].map {|f| require f }

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
