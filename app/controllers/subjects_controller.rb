class SubjectsController < ApplicationController
  before_action :load_subject, only: [:edit, :update]

  def new
    @subject = Subject.new
    @subject.assigned_model = %w(sav pav).sample
    @subject.save
    # We store an encrypted cookie with the id to continue later
    cookies.encrypted[:subject_id] = @subject.id.to_s
    redirect_to [:new, @subject, :car]
  end

  def edit; end

  def update
    if @subject.update_attributes(subject_form_params)
      flash[:success] = t '.thanks_for_participating'
      cookies.delete :subject_id # Delte cookie so that the questionary is no longer availabel to continue
      redirect_to '/'
    else
      flash[:error] = t 'shared.error'
      render :edit
    end
  end

  private

  def load_subject
    @subject = Subject.find(params[:id])
  end

  def subject_form_params
    params.require(:subject).permit(:email, :birthyear, :gender, :income, :pt_connection_duration, :pt_connection_interval,
                                    :plz, :city, :education)
  end
end
