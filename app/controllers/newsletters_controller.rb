class NewslettersController < ApplicationController
  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.create(newsletter_params)
    flash[:success] = t '.success'
    redirect_to root_path
  end

  def newsletter_params
    params.require(:newsletter).permit(:email)
  end
end
