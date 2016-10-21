class SubjectsController < ApplicationController
  before_filter :load_subject, only: [:edit, :update]
  
  def new
    @subject = Subject.new
    @subject.save
    # We store an encrypted cookie with the id to continue later
    cookies.encrypted[:subject_id] = @subject.id.to_s
    redirect_to [@subject, :routes]
  end
  
  def edit
  end
  
  def update
    if @subject.update_attributes(subject_form_params)
      flash.now[:danger] = t '.thanks_for_participating'
      redirect_to '/'
    else
      render :edit
    end
  end
  private
  
  def load_subject
    @subject = Subject.find(params[:id])
  end
  
  def subject_form_params
    params.require(:subject).permit(:email, :birthyear)
  end
end
