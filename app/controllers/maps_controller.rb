class MapsController < ApplicationController
  def index
    @activities = Activity.all.map { |activity| ActivityPresenter.new(activity) }
  end
end
