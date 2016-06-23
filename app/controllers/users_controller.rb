class UsersController < ApplicationController

  def create
    @user = User.new(user_params_signup)

    if @user.valid?
      @user.save
      flash[:notice] = "User created successfully."
    else
      flash[:notice] = @user.errors.full_messages
    end
    redirect_to(:controller => 'ide', :action => 'index')
  end

  private
  def user_params_signup
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation)
  end
end
