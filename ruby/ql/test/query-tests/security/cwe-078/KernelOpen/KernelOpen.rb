class UsersController < ActionController::Base
  def create
    file = params[:file] # $ Source
    open(file) # $ Alert // BAD
    IO.read(file) # $ Alert // BAD
    IO.write(file) # $ Alert // BAD
    IO.binread(file) # $ Alert // BAD
    IO.binwrite(file) # $ Alert // BAD
    IO.foreach(file) # $ Alert // BAD
    IO.readlines(file) # $ Alert // BAD
    URI.open(file) # $ Alert // BAD

    IO.read(File.join(file, "")) # $ Alert // BAD - file as first argument to File.join
    IO.read(File.join("", file)) # GOOD - file path is sanitised by guard

    File.open(file).read # GOOD

    if file == "some/const/path.txt"
      open(file) # GOOD - file path is sanitised by guard
    end

    if %w(some/const/1.txt some/const/2.txt).include? file
      IO.read(file) # GOOD - file path is sanitised by guard
    end

    open(file) # $ Alert // BAD - sanity check to verify that file was not mistakenly marked as sanitized
  end
end
