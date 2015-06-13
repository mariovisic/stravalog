class Activity < ActiveRecord::Base
  serialize :strava_data, ActiveRecord::Coders::NestedHstore
end
