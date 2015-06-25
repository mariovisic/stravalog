class Activity < ActiveRecord::Base
  extend FriendlyId

  serialize :strava_data, ActiveRecord::Coders::NestedHstore
  serialize :strava_streams_data, ActiveRecord::Coders::NestedHstore
  friendly_id :title, use: :slugged
end
