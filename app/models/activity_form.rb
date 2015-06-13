class ActivityForm
  include ActiveModel::Model
  attr_accessor :strava_activity_id, :title, :body

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

  def save
    Activity.create!({
      title: title,
      body: body,
      strava_data: strava_data,
      created_at: Time.parse(strava_data[:start_date_local]),
      updated_at: Time.now
    })
  end

  def has_no_strava_data?
    strava_data.blank?
  end

  private

  def strava_data
    @strava_data ||= begin
                       data = STRAVA_API_CLIENT.retrieve_an_activity(strava_activity_id)
                       # LOL, I don't know why it sometimes comes back as an array here!!!
                       if data.is_a?(Array)
                         data = data.first
                       end

                       data.with_indifferent_access
                     end
  end
end
