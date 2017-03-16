class FutureProfilesController < ProfilesController
  def show
    @subject.assigned_model = params[:model] if params[:model]
  end
end
