class ActivityPresenter < Struct.new(:activity)
  delegate :title, :body, to: :activity

  def self.to_partial_path
    'activity'
  end

  def date
    "#{activity.created_at.strftime("#{activity.created_at.day.ordinalize} %b %Y")}"
  end

  def to_model
    activity
  end

  def lapped?
    activity.strava_segment_id.present?
  end

  # FIXME: Needs a cleanup
  def laps
    efforts = activity.strava_data['segment_efforts'].select do |segment_effort|
      segment_effort['segment']['id'].to_i ==  activity.strava_segment_id
    end

    fastest_time = efforts.map { |effort| effort['elapsed_time'] }.min

    efforts.each_with_index.map do |effort, index|
      OpenStruct.new({
        number: index + 1,
        time: Time.at(effort['elapsed_time']).utc.strftime("%H:%M:%S"),
        speed: "#{((effort['segment']['distance'] / effort['elapsed_time']).to_f * 3.6).round(2)} km/h",
        fastest?: effort['elapsed_time'] == fastest_time
      })
    end
  end

  def short_summary_paragraphs(paragraphs)
    array = activity.body.gsub("\r", "\n").split("\n").reject(&:blank?)
    paragraphs = array.take(paragraphs) + [yield]

    ActionController::Base.helpers.simple_format(paragraphs.join("\n\n"))
  end

  def streams_json
    activity.strava_streams_data['streams'].to_json
  end

  def lat_lng_json_data
    if activity.strava_streams_data['streams'].blank?
      [].to_json
    else
      activity.strava_streams_data['streams'].detect { |stream| stream['type'] == 'latlng' }['data'].to_json
    end
  end

  def polyline
    activity.strava_data['map'].fetch('polyline', nil)
  end
end
