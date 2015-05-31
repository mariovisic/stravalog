class Concerns::AuthenticatedSession
  def initialize(storage)
    @storage = storage
  end

  def create(strava_athelete_id)
    @storage[:logged_in] = '1'
  end

  def delete
    @storage[:logged_in] = nil
  end

  def signed_in?
    @storage[:logged_in].present?
  end
end

