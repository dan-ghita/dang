class IdeController < ApplicationController
  def index
    @user = User.new
  end

  def eval
    code = params[:code]
    unless code.nil?
      result = Interpreter.interpret(code)
    end

    render :json => result
  end
end
