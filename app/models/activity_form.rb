class ActivityForm
  include ActiveModel::Model
  attr_accessor :strava_activity_id

  def self.model_name
    Activity.model_name
  end
end
