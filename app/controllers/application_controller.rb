class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def authenticated_session
    @authenticated_session ||= Concerns::AuthenticatedSession.new(session)
  end
  helper_method :authenticated_session

  def title
    @title ||= Title.new(@page_title)
  end
  helper_method :title
end
