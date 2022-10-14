class UsersController < ActionController::Base
  def create
    file = params[:file]
    open(file) # BAD
    IO.read(file) # BAD

    File.open(file).read # GOOD

    if file == "some/const/path.txt"
      open(file) # GOOD - file path is sanitised by guard
    end

    if %w(some/const/1.txt some/const/2.txt).include? file
      IO.read(file) # GOOD - file path is sanitised by guard
    end
  end
end
