class UsersController < ActionController::Base
  CONSTANT = "constant"
  CONSTANT_WITH_FREEZE = "constant-with-freeze".freeze

  def create
    file = params[:file]
    open(file) # $ Alert // BAD
    IO.read(file) # $ Alert // BAD
    IO.write(file) # $ Alert // BAD
    IO.binread(file) # $ Alert // BAD
    IO.binwrite(file) # $ Alert // BAD
    IO.foreach(file) # $ Alert // BAD
    IO.readlines(file) # $ Alert // BAD
    URI.open(file) # $ Alert // BAD

    File.open(file).read # GOOD

    Kernel.open(file) # $ Alert // BAD

    File.open(file, "r") # GOOD

    Kernel.open("constant") # GOOD

    IO.read("constant") # GOOD

    Kernel.open("this is #{fine}") # GOOD

    Kernel.open("#{this_is} bad") # $ Alert // BAD

    open("| #{this_is_an_explicit_command} foo bar") # GOOD

    IO.foreach("|" + EnvUtil.rubybin + " -e 'puts :foo; puts :bar; puts :baz'") {|x| a << x } # GOOD

    IO.write(File.join("foo", "bar.txt"), "bar") # GOOD

    IO.read(CONSTANT) # GOOD

    IO.read(CONSTANT + file) # GOOD

    IO.read(CONSTANT_WITH_FREEZE) # GOOD

    IO.read(CONSTANT_WITH_FREEZE + file) # GOOD
    
    open.where(external: false) # GOOD - an open method is called withoout arguments
    
    open(file) # $ Alert // BAD - sanity check to verify that file was not mistakenly marked as sanitized
  end
end
