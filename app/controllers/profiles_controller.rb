class ProfilesController < ApplicationController
  before_action :load_subject

  private

  def load_subject
    @subject = Subject.find(params[:subject_id])
  end
end
