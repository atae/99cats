class SessionController < ApplicationController
  before_action :redirect_current_user, except:[:destroy]
  def new
    render :new
  end

  #log in
  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    # if user.nil?
    #   render :new
    # else
      login_user!(user)
    # end
  end

  #log out
  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    end
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
