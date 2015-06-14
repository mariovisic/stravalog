class Activity < ActiveRecord::Base
  extend FriendlyId

  serialize :strava_data, ActiveRecord::Coders::NestedHstore
  friendly_id :title, use: :slugged
end
