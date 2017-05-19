class PagesController < ApplicationController
  before_action :load_subject_from_previous

  def show
    @subject.assigned_model = params[:model] if @subject && params[:model]
    render params[:id]
  end

  private

  def load_subject_from_previous
    @subject = Subject.where(id: cookies.encrypted[:subject_id]).first
  end
end
