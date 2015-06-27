class AddStravaSegmentIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :strava_segment_id, :integer
  end
end
