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

  # FIXME: Needs a cleanup
  def laps_json
    if activity.strava_segment_id.blank?
      laps = []
    else
      efforts = activity.strava_data['segment_efforts'].select do |segment_effort|
        segment_effort['segment']['id'].to_i ==  activity.strava_segment_id
      end

      fastest_lap = efforts.map { |effort| effort['elapsed_time'] }.min

      laps = efforts.each_with_index.map do |effort, index|
        {
          time: effort['elapsed_time'],
          speed: effort['segment']['distance'] / effort['elapsed_time']
        }
      end
    end

    { :laps => laps, :fastest_lap_time => fastest_lap }.to_json
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
