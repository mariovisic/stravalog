class Concerns::AuthenticatedSession
  def initialize(storage)
    @storage = storage
  end

  def create(strava_auth_token)
    @storage[:strava_auth_token] = strava_auth_token
  end

  def delete
    @storage[:strava_auth_token] = nil
  end

  def signed_in?
    @storage[:strava_auth_token].present?
  end
end
