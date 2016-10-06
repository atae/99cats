class UsersController < ApplicationController
  before_action :redirect_current_user
    def new
      render :new
    end

    def create
      user=User.new(user_params)
      if user.save
        login_user!(user)
      else
        flash[:errors] = user.errors.full_messages
        redirect_to new_user_url
      end
    end



    private
    def user_params
      params.require(:user).permit(:user_name, :password)
    end
end
