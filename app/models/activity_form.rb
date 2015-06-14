class ActivityForm
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

  def fetch_strava_data
    strava_activity_id.presence && STRAVA_API_CLIENT.retrieve_an_activity(strava_activity_id).with_indifferent_access.tap do |data|
      Rails.cache.write(cache_key, data)
    end
  rescue Strava::Api::V3::ClientError => e
    errors.add(:strava_activity_id, e.message)
    nil
  end

  def cached_strava_data
    Rails.cache.fetch(cache_key)
  end

  def cache_key
    "strava_activity_#{strava_activity_id}"
  end
end
