require 'database_cleaner'
require 'factory_girl'

# RSpec
# spec/support/factory_girl.rb
RSpec.configure do |config|

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end