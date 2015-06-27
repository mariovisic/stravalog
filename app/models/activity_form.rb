class ActivityForm
  include ActiveModel::Model
  attr_accessor :strava_activity_id, :strava_segment_id, :title, :body

  validates :body, :title, presence: true

  def self.model_name
    Activity.model_name
  end

  def body
    defined?(@body) ? @body : strava_data.activity_data[:description]
  end

  def title
    defined?(@title) ? @title : strava_data.activity_data[:name]
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
    !strava_data.valid?
  end

  def segment_collection
    strava_data.activity_data[:segment_efforts].map { |segment_effort| [segment_effort['name'], segment_effort['segment']['id']] }.uniq
  end

  private

  def update
    existing_activity.update_attributes!({
      title: title,
      body: body,
      strava_segment_id: strava_segment_id
    })
  end

  def create
    Activity.create!({
      title: title,
      body: body,
      strava_activity_id: strava_activity_id,
      strava_segment_id: strava_segment_id,
      strava_data: strava_data.activity_data,
      strava_streams_data: strava_data.streams_data,
      created_at: Time.parse(strava_data.activity_data[:start_date_local]),
      updated_at: Time.now
    })
  end

  def existing_activity
    Activity.where(strava_activity_id: strava_activity_id).first
  end

  def strava_data
    @strava_data ||= StravaData.new(strava_activity_id)
  end
end
