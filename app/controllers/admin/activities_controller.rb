class Admin::ActivitiesController < Admin::BaseController
  def new
    @activity_form = ActivityForm.new(activity_params)
  end

  private

  def activity_params
    params.require(:activity)
  end
end
