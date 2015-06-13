class SessionsController < ApplicationController
  def create
    if authentication_successful?
      authenticated_session.create(strava_auth_token)
      flash[:notice] = 'Logged in, well done!'
      redirect_to admin_root_path
    else
      flash[:alert] = 'Unable to login, sorry'
      redirect_to root_path
    end
  end

  def destroy
    authenticated_session.delete

    redirect_to root_path
  end

  private

  def authentication_successful?
    strava_athlete_id == owner_strava_athlete_id
  end

  def owner_strava_athlete_id
    ENV['STRAVA_ATHELETE_ID'].to_i
  end

  def strava_athlete_id
    @strava_athlete_id ||= auth_hash[:uid].to_i
  end

  def strava_auth_token
    auth_hash.fetch(:credentials, { }).fetch(:token, nil)
  end

  def auth_hash
    request.env.fetch('omniauth.auth', { })
  end
end
