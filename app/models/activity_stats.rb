class ActivityStats < Struct.new(:activity)
  def moving_time
    formatted_duration(strava_data[:moving_time].to_i)
  end

  def metres_climbed
    "#{strava_data[:total_elevation_gain].to_i}m"
  end

  def average_speed
    "#{(strava_data[:average_speed].to_f * 3.6).round(2)} km/h"
  end

  private

  def formatted_duration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def strava_data
    activity.strava_data.with_indifferent_access
  end
end
