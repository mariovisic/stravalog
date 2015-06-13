class Admin::BaseController < ApplicationController
  before_filter :ensure_logged_in

  private

  def ensure_logged_in
    unless authenticated_session.signed_in?
      redirect_to '/auth/strava'
    end
  end
end
