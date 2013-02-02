$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler/setup'

require 'active_record'

require 'acts_as_shopping_cart'

RSpec.configure do |config|
  config.mock_with :rspec
end
