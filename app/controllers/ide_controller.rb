class IdeController < ApplicationController
  def index

  end

  def eval
    code = params[:code]
    unless code.nil?
      result = Interpreter.interpret(code)
    end

    render :json => result
  end
end
