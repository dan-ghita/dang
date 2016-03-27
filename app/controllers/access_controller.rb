class AccessController < ApplicationController
  def login
    if params[:username] && params[:password]

      user = User.where(:email => params[:username]).first

      if user && user.authenticate(params[:password])
        flash[:notice] = "Logged in successfully!"
        session[:user_id] = user.id
        session[:username] = user.email
      else
        flash[:notice] = "Wrong username or password!"
      end
    end

    redirect_to(:controller => 'ide', :action => 'index')
  end

  def logout
    flash[:notice] = "Logged out successfuly!"
    session[:user_id] = nil
    session[:username] = nil
    redirect_to(:controller => 'ide', :action => 'index')
  end

end
