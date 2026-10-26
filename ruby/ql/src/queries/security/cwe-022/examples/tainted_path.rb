class FilesController < ActionController::Base
  def first_example
    # BAD: This could read any file on the file system
    @content = File.read params[:path]
  end

  def second_example
    # BAD: This could still read any file on the file system
    @content = File.read "/home/user/#{ params[:path] }"
  end
end
