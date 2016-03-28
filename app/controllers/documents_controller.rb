class DocumentsController < ApplicationController

  def create
    code = params[:code]
    file_name = params[:name]

    directory_name = Rails.root.join('public', 'saved-scripts', session[:username])
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    # Write file to public/Uploads
    File.open(Rails.root.join('public', 'saved-scripts', session[:username], file_name), 'wb') do |file|
      file.write(code)
    end

    current_user = User.find(session[:user_id])
    doc = Document.create(:name => file_name, :path => 'saved-scripts/' + session[:username] + '/' + file_name)
    current_user.documents << doc

    render :json => { success: true, message: "File #{file_name} saved successfully!", name: file_name }
  end

  def show
    @document = Document.find params[:id]
  end

end
