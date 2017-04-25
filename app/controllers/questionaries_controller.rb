class QuestionariesController < ApplicationController
  before_action :load_subject
  before_action :assign_page

  def create
    update_questionary
  end

  def update
    update_questionary
  end

  private

  def update_questionary
    if @questionary.update_attributes(questionary_params)
      @questionary.page = @questionary.page.to_i + 1
      if @questionary.page == 4
        redirect_to edit_subject_path(@subject)
        return
      end
    end
    render :edit
  end

  def load_subject
    @subject = Subject.find(params[:subject_id])
    @questionary = @subject.questionary || Questionary.new
    @questionary.subject = @subject
  end

  def assign_page
    @questionary.page = questionary_params[:page].to_i || 1
  end

  def questionary_params
    params.require(:questionary).permit! # We don't care about security here as long as it just affects questionary data
  end
end
