require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  #before_action :ensure_authenticated_user

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token


  # def ensure_authenticated_user
  #   if cookies.signed[:user_id]
  #     authenticate_user(cookies.signed[:user_id])
  #     puts "ñññññññññññññññññññññññññññññññññññññññññññññññ"
  #     puts @current_user
  #   else
  #     redirect_to(new_session_url)
  #   end
  # end

  def authenticate_user(user_id)
    if authenticated_user = User.find_by(id: user_id)
      cookies[:user] = user_id
      cookies.signed[:user_id] ||= user_id
      @current_user = User.find(cookies.signed[:user_id])
      puts "*****************************************************"
      puts @current_user
    end
  end

  def unauthenticate_user
    ActionCable.server.disconnect(current_user: @current_user)
    @current_user = nil
    cookies.delete(:user_id)
  end

end
