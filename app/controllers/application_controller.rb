class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticated_session
    @authenticated_session ||= Concerns::AuthenticatedSession.new(session)
  end
  helper_method :authenticated_session
end
