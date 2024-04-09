require 'pathname'

class FilesController < ActionController::Base
  def safe_example
    filename = params[:path]
    user_directory = "/home/#{current_user}/public" # Assuming `current_user` method returns the user's name

    public_folder = Pathname.new(user_directory).cleanpath.to_s
    file_path = Pathname.new(File.join(user_directory, filename)).cleanpath.to_s

    # GOOD: Ensure that the path stays within the public folder
    if !file_path.start_with?(public_folder + File::SEPARATOR)
      raise ArgumentError, "Invalid filename"
    else
      @content = File.read(file_path)
    end
  end
end