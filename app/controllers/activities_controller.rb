class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order('id desc')
  end

  def show
    @activity = Activity.find(params[:id])
  end
end
