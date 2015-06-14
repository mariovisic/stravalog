class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order('id desc').map { |activity| ActivityPresenter.new(activity) }
  end

  def show
    @activity = Activity.find(params[:id])
    @activity_stats = ActivityStats.new(@activity)
    @page_title = @activity.title
  end
end
