class UsersController < ActionController::Base

  def show
    printf(params[:format], arg) # $ Alert // BAD
    Kernel.printf(params[:format], arg) # $ Alert // BAD
    
    printf(params[:format]) # GOOD
    Kernel.printf(params[:format]) # GOOD

    printf(IO.new(1), params[:format], arg) # $ Alert // BAD
    Kernel.printf(IO.new(1), params[:format], arg) # $ Alert // BAD

    printf("%s", params[:format]) # GOOD
    Kernel.printf("%s", params[:format]) # GOOD
    fmt = "%s"
    printf(fmt, params[:format]) # GOOD

    printf(IO.new(1), params[:format]) # $ Alert // GOOD [FALSE POSITIVE]
    Kernel.printf(IO.new(1), params[:format]) # $ Alert // GOOD [FALSE POSITIVE]
    
    str1 = Kernel.sprintf(params[:format], arg) # $ Alert // BAD
    str2 = sprintf(params[:format], arg) # $ Alert // BAD

    str1 = Kernel.sprintf(params[:format]) # GOOD
    str2 = sprintf(params[:format]) # GOOD
    
    stdout = IO.new 1
    stdout.printf(params[:format], arg) # $ Alert // BAD

    stdout.printf(params[:format]) # GOOD
    
    # Taint via string concatenation
    printf("A log message: " + params[:format], arg) # $ Alert // BAD

    # Taint via string interpolation
    printf("A log message: #{params[:format]}", arg) # $ Alert // BAD

    # Using String#
    "A log message #{params[:format]} %{foo}" % {foo: "foo"} # $ Alert // BAD

    # String# with an array
    "A log message #{params[:format]} %08x" % ["foo"] # $ Alert // BAD
  end
end
