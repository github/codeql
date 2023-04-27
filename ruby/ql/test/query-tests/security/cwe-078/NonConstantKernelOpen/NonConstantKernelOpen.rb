class UsersController < ActionController::Base
  CONSTANT = "constant"
  CONSTANT_WITH_FREEZE = "constant-with-freeze".freeze

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

    File.open(file).read # GOOD

    Kernel.open(file) # BAD

    File.open(file, "r") # GOOD

    Kernel.open("constant") # GOOD

    IO.read("constant") # GOOD

    Kernel.open("this is #{fine}") # GOOD

    Kernel.open("#{this_is} bad") # BAD

    open("| #{this_is_an_explicit_command} foo bar") # GOOD

    IO.foreach("|" + EnvUtil.rubybin + " -e 'puts :foo; puts :bar; puts :baz'") {|x| a << x } # GOOD

    IO.write(File.join("foo", "bar.txt"), "bar") # GOOD

    IO.read(CONSTANT) # GOOD

    IO.read(CONSTANT + file) # GOOD

    IO.read(CONSTANT_WITH_FREEZE) # GOOD

    IO.read(CONSTANT_WITH_FREEZE + file) # GOOD
    
    open.where(external: false) # GOOD - an open method is called withoout arguments
    
    open(file) # BAD - sanity check to verify that file was not mistakenly marked as sanitized
  end
end
