class AddStravaStreamsDataToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :strava_streams_data, :hstore, default: ''
  end
end
