class ActivityForm
  STREAM_TYPES = %w(time latlng distance altitude velocity_smooth grade_smooth).join(',')

  include ActiveModel::Model
  attr_accessor :strava_data, :strava_activity_id, :title, :body

  validates :body, :title, presence: true

  def self.model_name
    Activity.model_name
  end

  def body
    defined?(@body) ? @body : strava_data[:description]
  end

  def title
    defined?(@title) ? @title : strava_data[:name]
  end

  def persisted?
    id.present?
  end

  def id
    existing_activity.try(:id)
  end

  def save
    if valid?
      persisted? ? update : create
    end
  end

  def has_no_strava_data?
    strava_data.blank?
  end

  private

  def update
    existing_activity.update_attributes!({
      title: title,
      body: body
    })
  end

  def create
    Activity.create!({
      title: title,
      body: body,
      strava_activity_id: strava_activity_id,
      strava_data: strava_data,
      strava_streams_data: strava_streams_data,
      created_at: Time.parse(strava_data[:start_date_local]),
      updated_at: Time.now
    })
  end

  def existing_activity
    Activity.where(strava_activity_id: strava_activity_id).first
  end

  def strava_data
    @strava_data ||= cached_strava_data || fetch_strava_data
  end

  def strava_streams_data
    @strava_streams_data ||= cached_strava_streams_data || fetch_strava_streams_data
  end

  def fetch_strava_data
    strava_activity_id.presence && STRAVA_API_CLIENT.retrieve_an_activity(strava_activity_id).with_indifferent_access.tap do |data|
      Rails.cache.write(strava_data_cache_key, data)
    end
  rescue Strava::Api::V3::ClientError => e
    errors.add(:strava_activity_id, e.message)
    nil
  end

  def fetch_strava_streams_data
    strava_activity_id.presence && { streams: STRAVA_API_CLIENT.retrieve_activity_streams(strava_activity_id, STREAM_TYPES).map(&:with_indifferent_access) }.tap do |data|
      Rails.cache.write(strava_streaming_data_cache_key, data)
    end
  rescue Strava::Api::V3::ClientError => e
    errors.add(:strava_activity_id, e.message)
    nil
  end

  def cached_strava_data
    Rails.cache.fetch(strava_data_cache_key)
  end

  def cached_strava_streams_data
    Rails.cache.fetch(strava_streaming_data_cache_key)
  end

  def strava_data_cache_key
    "strava_activity_#{strava_activity_id}"
  end

  def strava_streaming_data_cache_key
    "strava_activity_streams_#{strava_activity_id}_#{STREAM_TYPES}"
  end
end
