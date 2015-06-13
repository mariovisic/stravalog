require 'rails_helper'

RSpec.feature 'Authentication' do
  before { Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:strava] }

  scenario 'logging in as the owner' do
    OmniAuth.config.mock_auth[:strava] = OmniAuth::AuthHash.new(:uid => ENV['STRAVA_ATHELETE_ID'], :credentials => { :token => '12'})

    visit '/admin'

    expect(page).to have_content('Logged in')
  end

  scenario 'logging in as another user' do
    OmniAuth.config.mock_auth[:strava] = OmniAuth::AuthHash.new(:uid => '10', :credentials => { :token => '12'})

    visit '/admin'

    expect(page).to have_content('Unable to login')
  end
end
