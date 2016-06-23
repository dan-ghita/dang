class IdeController < ApplicationController
  def index
    @user = User.new

    unless session[:user_id].nil?
      @files = Document.where :user_id => session[:user_id]
    end
  end

  def eval
    code = params[:code]
    unless code.nil?
      result = Interpreter.interpret(code)
    end

    render :json => result
  end
end
