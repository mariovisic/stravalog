class Admin::DashboardController < Admin::BaseController
  def index
    @acitivities_count = Activity.count
  end
end
