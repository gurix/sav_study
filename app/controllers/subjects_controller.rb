require 'csv_export'
require 'json'
class SubjectsController < ApplicationController
  # include ActionController::Live
  before_action :load_subject, only: [:edit, :update]
  before_action :ask_for_password, only: :index, if: -> { Rails.env.production? }

  def index
    respond_to do |format|
      format.csv { render_csv }
      format.json { render_json }
    end
  end

  def new
    @subject = Subject.new
    @subject.assigned_model = %w(sav pav).sample
    @subject.panel_id = cookies.encrypted[:panel_id] # Store the panel id to determine wether the subject is from a panel
    @subject.save
    # We store an encrypted cookie with the id to continue later
    cookies.encrypted[:subject_id] = @subject.id.to_s
    redirect_to [:new, @subject, :car]
  end

  def edit; end

  def update
    if @subject.update_attributes(subject_form_params)
      cookies.delete(:subject_id) && cookies.delete(:panel_id) # Delte cookie so that the questionary is no longer availabel to continue

      redirect_to(redirect_path)
    else
      flash[:error] = t 'shared.error'
      render :edit
    end
  end

  private

  def redirect_path
    tmp = new_newsletter_path
    if @subject.panel_id.present?
      project_token = 'd5ca5586-67d9-47a3-a2c2-e4a07f20db0d'
      # A valid session has to last at least 5 minutes
      tmp = "https://s.cint.com/Survey/#{((@subject.updated_at - @subject.created_at).to_i < 5 * 60 ? 'Finished' : 'Complete')}?ProjectToken=#{project_token}"
    end
    tmp
  end

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

  def render_json
    response.headers['Content-Disposition'] = "attachment; filename=sav_study_#{DateTime.now.strftime('%Y%m%d')}.json"
    # response.headers['Content-Disposition'] = "inline; filename=sav_study_#{DateTime.now.strftime("%Y%m%d")}.csv"
    response.headers['Content-Type'] = 'text/json'
    response.stream.write '['
    # ... and generate a line for each session.
    Subject.each_with_index do |subject, index|
      response.stream.write JSON.pretty_generate(JSON.parse(subject.to_json))
      # response.stream.write subject.as_json
      response.stream.write ',' if index < Subject.count - 1
    end
  ensure
    response.stream.write ']'
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
