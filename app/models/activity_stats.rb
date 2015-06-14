class ActivityStats < Struct.new(:activity)
  def moving_time
    formatted_duration(strava_data[:moving_time].to_i)
  end

  def metres_climbed
    "#{strava_data[:total_elevation_gain].to_i} metres"
  end

  def average_speed
    "#{(strava_data[:average_speed].to_f * 3.6).round(2)} km/h"
  end

  def distance
    "#{(strava_data[:distance].to_f / 1000).round(2)} km"
  end

  private

  def formatted_duration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def strava_data
    activity.strava_data.with_indifferent_access
  end
end
