class SessionsController < ApplicationController
  skip_before_action :ensure_authenticated_user, only: %i( new create )

  def new
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render(json: {users: @users} ) }
    end
  end

  def create
    puts "99999999999999999999999999999999999999999999999999999999999"
    if params[:trigger] == 'true'
      user = User.create(ip: request.remote_ip)
      authenticate_user(user.id)
      message = Message.create(user: user)
      redirect_to message_path(message.id)
    end
  end


  def destroy
    unauthenticate_user
    redirect_to new_session_url
  end
end