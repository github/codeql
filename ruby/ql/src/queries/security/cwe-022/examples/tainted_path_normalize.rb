class FilesController < ActionController::Base
  def safe_example
    filename = params[:path]
    # GOOD: Ensure that the filename has no path separators or parent directory references
    if filename.include?("..") || filename.include?("/") || filename.include?("\\")
      raise ArgumentError, "Invalid filename"
    else
      # Assuming files are stored in a specific directory, e.g., /home/user/files/
      @content = File.read("/home/user/files/#{filename}")
    end
  end
end