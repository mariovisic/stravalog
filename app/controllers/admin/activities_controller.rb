class Admin::ActivitiesController < Admin::BaseController
  def new
    @activity_form = ActivityForm.new(activity_params)

    if @activity_form.has_no_strava_data?
      redirect_to admin_root_path, flash: { alert: @activity_form.errors.full_messages.to_sentence }
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

  def edit
    @activity = Activity.friendly.find(params[:id])
    @activity_form = ActivityForm.new(@activity.attributes.with_indifferent_access.slice(:title, :body, :strava_activity_id, :strava_data))
  end

  def update
    @activity_form = ActivityForm.new(activity_params)

    if @activity_form.save
      redirect_to admin_root_path, flash: { notice: 'Updated activity' }
    else
      render :edit
    end
  end

  private

  def activity_params
    params.require(:activity)
  end
end
