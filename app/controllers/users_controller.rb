class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  def show
    @user = current_user
    @preferences = Preference.new
  end

  def edit
    @user = current_user
  end
  def index
  end
  def update
    @user = current_user
      if @user.update(update_params)
        redirect_to @user, notice: 'user was successfully updated.'
      else
        render action: 'edit'
      end
  end

  private

  def update_params
    params.require(:user).permit(:weight, :height, :username, :activity, :goal)
  end
end
