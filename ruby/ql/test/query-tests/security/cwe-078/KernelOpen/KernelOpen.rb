class UsersController < ActionController::Base
  def create
    file = params[:file]
    open(file) # BAD
    IO.read(file) # BAD
    IO.write(file) # BAD
    IO.binread(file) # BAD
    IO.binwrite(file) # BAD
    IO.foreach(file) # BAD
    IO.readlines(file) # BAD
    URI.open(file) # BAD

    IO.read(File.join(file, "")) # BAD - file as first argument to File.join 
    IO.read(File.join("", file)) # GOOD - file path is sanitised by guard

    File.open(file).read # GOOD

    if file == "some/const/path.txt"
      open(file) # GOOD - file path is sanitised by guard
    end

    if %w(some/const/1.txt some/const/2.txt).include? file
      IO.read(file) # GOOD - file path is sanitised by guard
    end

    open(file) # BAD - sanity check to verify that file was not mistakenly marked as sanitized
  end
end
