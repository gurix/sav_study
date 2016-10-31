class PagesController < ApplicationController
  def index
    load_subject_from_previous
  end

  private

  def load_subject_from_previous
    @subject = Subject.where(id: cookies.encrypted[:subject_id]).first
  end
end
