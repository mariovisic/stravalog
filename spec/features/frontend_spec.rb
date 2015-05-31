require 'rails_helper'

RSpec.feature 'Viewing the front end' do
  before do
    Activity.create!(title: 'Super hard session', body: ['It was a really super hard session', ('hello ' * 1000), 'I promise'].join, strava_data: { })
  end

  scenario 'showing a list of recent activities' do
    visit '/'

    expect(page).to have_content('Super hard session')
    expect(page).to have_content('It was a really super hard session')
  end

  scenario 'truncating activities on the homepage' do
    visit '/'

    expect(page).to have_content('It was a really super hard session')
    expect(page).to have_no_content('I promise')

    click_link 'Read more...'

    expect(page).to have_content('I promise')
  end
end
