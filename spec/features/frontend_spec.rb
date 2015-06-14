require 'rails_helper'

RSpec.feature 'Viewing the front end' do
  before { Activity.create!(title: 'Super hard session', body: ['It was a really super hard session', ('hello ' * 1000), ('there ' * 1000), 'I promise'].join("\n\n"), strava_data: { }) }

  scenario 'showing a list of recent activities' do
    visit root_path

    expect(page).to have_content('Super hard session')
    expect(page).to have_content('It was a really super hard session')
  end

  scenario 'truncating activities on the homepage' do
    visit root_path

    expect(page).to have_content('It was a really super hard session')
    expect(page).to have_no_content('I promise')

    click_link 'read more'

    expect(page).to have_content('I promise')
  end
end
