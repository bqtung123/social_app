class ApplicationController < ActionController::Base
  include SessionsHelper

  def logged_in_user
    return if logged_in?

    store_location
    flash[:success] = "Please log in."
    redirect_to login_url
  end
end
