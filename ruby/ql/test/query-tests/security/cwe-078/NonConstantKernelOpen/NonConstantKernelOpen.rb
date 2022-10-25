class UsersController < ActionController::Base
  def create
    file = params[:file]
    open(file) # BAD
    IO.read(file) # BAD

    File.open(file).read # GOOD

    Kernel.open(file) # BAD

    File.open(file, "r") # GOOD

    Kernel.open("constant") # GOOD

    IO.read("constant") # GOOD

    Kernel.open("this is #{fine}") # GOOD

    Kernel.open("#{this_is} bad") # BAD

    open("| #{this_is_an_explicit_command} foo bar") # GOOD
  end
end
