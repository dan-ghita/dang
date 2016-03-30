class DocumentsController < ApplicationController

  def create
    code = params[:code]
    file_name = params[:name]

    directory_name = Rails.root.join('public', 'saved-scripts', session[:username])
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    # Write file to public/saved-scripts
    File.open(Rails.root.join('public', 'saved-scripts', session[:username], file_name), 'wb') do |file|
      file.write(code)
    end

    current_user = User.find(session[:user_id])
    @document = Document.create(:name => file_name, :path => 'saved-scripts/' + session[:username] + '/' + file_name)
    current_user.documents << @document

    render :json => { success: true, message: "File #{file_name} saved successfully!", document: @document }
  end

  def show
    @document = Document.find params[:id]

    code = ''

    if @document.nil?
      success = false
      error = 'Document not found'
    else
      full_path = Rails.root.join('public', @document.path)
      if File.exist? full_path
        success = true
        error = ''
        file = File.open(full_path, 'rb')
        code = file.read
      else
        success = false
        file_name = @document.path.split('/').last
        error = "File #{ file_name } not found"
      end
    end

    render :json => { success: success, error: error, code: code, name: @document.name }
  end

  def update
    @document = Document.find params[:id]
    full_path = Rails.root.join('public', @document.path)

    if File.exist? full_path
      file = File.open(full_path, 'w')
      file.write(params[:code])
      file.close
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :not_found
    end
  end
end
