class RoutesController < ApplicationController
  before_action :load_subject
  before_action :test_criteria
  before_action :load_route, only: [:edit, :update, :destroy]

  def index
    @routes = @subject.routes
  end

  def new
    @route = Route.new
  end

  def edit
    # render :edit
  end

  def update
    if @route.update_attributes(route_form_params)
      redirect_to [@subject, :routes]
    else
      flash.now[:error] = t 'shared.error'
      render :edit
    end
  end

  def destroy
    @route.destroy
    redirect_to [@subject, :routes]
  end

  def create
    @route = Route.new route_form_params
    @route.subject = @subject
    if @route.save
      redirect_to [@subject, :routes]
    else
      flash.now[:error] = t 'shared.error'
      render :new
    end
  end

  private

  def load_subject
    @subject = Subject.find(params[:subject_id])
  end

  def load_route
    @route = @subject.routes.find(params[:id])
  end

  def route_form_params
    params.require(:route).permit(:start_point, :end_point, :purpose, :cargo, :interval,
                                  by_car_attributes: [:id, :distance, :duration, :stopp_and_go],
                                  by_foot_attributes: [:id, :distance, :duration],
                                  by_train_attributes: [:id, :distance, :duration],
                                  by_bicycle_attributes: [:id, :distance, :duration],
                                  by_local_line_attributes: [:id, :distance, :duration])
  end

  def test_criteria
    return true if @subject.car.is_commuter
    flash[:danger] = t('.does_not_meet_criteria')
    redirect_to(@subject.panel_id.present? ? 'https://s.cint.com/Survey/EarlyScreenOut?ProjectToken=d73a8323-6030-4348-9879-8c37abf55bce' : root_path)
  end
end
