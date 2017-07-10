class SubjectsController < ApplicationController
  # include ActionController::Live
  before_action :load_subject, only: [:edit, :update]
  before_action :ask_for_password, only: :index, if: -> { Rails.env.production? }

  def index
    render_csv
  end

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
      cookies.delete :subject_id # Delte cookie so that the questionary is no longer availabel to continue
      redirect_to new_newsletter_path
    else
      flash[:error] = t 'shared.error'
      render :edit
    end
  end

  private

  def render_csv
    csv_export = CSVExport.new
    response.headers['Content-Disposition'] = "attachment; filename=sav_study_#{DateTime.now.strftime('%Y%m%d')}.csv"
    # response.headers['Content-Disposition'] = "inline; filename=sav_study_#{DateTime.now.strftime("%Y%m%d")}.csv"
    response.headers['Content-Type'] = 'text/csv'

    # Write csv header once ...
    response.stream.write csv_export.header

    # ... and generate a line for each session.
    Subject.each do |subject|
      response.stream.write csv_export.for_subject(subject)
    end
  ensure
    response.stream.close
  end

  def load_subject
    @subject = Subject.find(params[:id])
  end

  def subject_form_params
    params.require(:subject).permit(:email, :birthyear, :gender, :income, :pt_connection_duration, :pt_connection_interval,
                                    :plz, :city, :education)
  end

  def ask_for_password
    authenticate_or_request_with_http_basic { |_username, password| password == ENV['PASSWORD'] }
  end
end
