RSpec.configure do |config|
  config.before(:suite) { OmniAuth.config.test_mode = true }
end
