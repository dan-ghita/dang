class SettingsController < ApplicationController
  def new
    settings = Setting.create :line_numbers => true, :auto_indent => true, :auto_correct => true
    current_user = User.find(session[:user_id])

    unless current_user.nil?
      current_user.setting = settings
    end

    settings
  end

  def create
  end

  def update

    unless session[:user_id].nil?
      setting = Setting.where(user_id: session[:user_id])[0]

      setting_name = params[:settingName]
      setting_value= params[:settingValue]

      setting[setting_name] = setting_value
      setting.save
    end
  end

  def edit
  end

  def destroy
  end

  def index
  end

  def show
    settings = Setting.where(user_id: session[:user_id])

    if settings == []
      settings = new
    end

    render :json => { settings: settings }
  end
end
