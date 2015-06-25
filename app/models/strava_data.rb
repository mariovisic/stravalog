class StravaData
  STREAM_TYPES = %w(time latlng distance altitude velocity_smooth grade_smooth).join(',')

  def initialize(activity_id)
    @activity_id = activity_id
  end

  def activity_data
    @activity_data ||= cached_activity_data || fetch_activity_data
  end

  def streams_data
    @streams_data ||= cached_streams_data || fetch_streams_data
  end

  def valid?
    activity_data.present?
  end

  private

  def fetch_activity_data
    @activity_id.presence && STRAVA_API_CLIENT.retrieve_an_activity(@activity_id).with_indifferent_access.tap do |data|
      Rails.cache.write(activity_cache_key, data)
    end
  rescue Strava::Api::V3::ClientError => e
    errors.add(:strava_activity_id, e.message)
    nil
  end

  def fetch_streams_data
    @activity_id.presence && { streams: STRAVA_API_CLIENT.retrieve_activity_streams(@activity_id, STREAM_TYPES).map(&:with_indifferent_access) }.tap do |data|
      Rails.cache.write(streams_cache_key, data)
    end
  rescue Strava::Api::V3::ClientError => e
    errors.add(:strava_activity_id, e.message)
    nil
  end

  def cached_activity_data
    Rails.cache.fetch(activity_cache_key)
  end

  def cached_streams_data
    Rails.cache.fetch(streams_cache_key)
  end

  def activity_cache_key
    "strava_activity_#{@activity_id}"
  end

  def streams_cache_key
    "strava_activity_streams_#{@activity_id}_#{STREAM_TYPES}"
  end
end
