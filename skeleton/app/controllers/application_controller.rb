class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    if user
      session[:session_token] = user.session_token
      redirect_to cats_url
    else
      # flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  def redirect_current_user
    redirect_to cats_url if current_user
  end

  def owns_cat?
    cats = current_user.cats
    if cats.find_by_id(params[:id]).nil?
      redirect_to cats_url
    end
  end

end
