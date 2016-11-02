class CarsController < ApplicationController
  before_action :load_subject

  def create
    render :new unless update_or_create
  end

  def update
    render :edit unless update_or_create
  end

  private

  def update_or_create
    if @car.update_attributes(car_form_params)
      redirect_to([@subject, :routes])
      return true
    else
      flash.now[:danger] = t 'shared.error'
    end
    false
  end

  def load_subject
    @subject = Subject.find(params[:subject_id])
    @car = @subject.car || Car.new(subject: @subject)
  end

  def car_form_params
    params.require(:car).permit(:category, :type_of_power)
  end
end
