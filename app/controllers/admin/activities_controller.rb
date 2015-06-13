class Admin::ActivitiesController < Admin::BaseController
  def new
    @activity_form = ActivityForm.new(activity_params)

    if @activity_form.has_no_strava_data?
      redirect_to admin_root_path, flash: { alert: 'Bad strava data' }
    end
  end

  def create
    @activity_form = ActivityForm.new(activity_params)

    if @activity_form.save
      redirect_to admin_root_path, flash: { notice: 'Created new activity' }
    else
      render :new
    end
  end

  private

  def activity_params
    params.require(:activity)
  end
end