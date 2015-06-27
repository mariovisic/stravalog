class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order('created_at desc').map { |activity| ActivityPresenter.new(activity) }
  end

  def show
    activity = Activity.friendly.find(params[:id])
    @activity_presenter = ActivityPresenter.new(activity)
    @activity_stats = ActivityStats.new(activity)
    @page_title = activity.title
  end
end
