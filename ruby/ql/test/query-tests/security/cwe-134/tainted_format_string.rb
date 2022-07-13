class UsersController < ActionController::Base

  def show
    printf(params[:format], arg) # BAD
    Kernel.printf(params[:format], arg) # BAD
    
    printf(params[:format]) # GOOD
    Kernel.printf(params[:format]) # GOOD

    printf(IO.new(1), params[:format], arg) # BAD
    Kernel.printf(IO.new(1), params[:format], arg) # BAD

    printf("%s", params[:format]) # GOOD
    Kernel.printf("%s", params[:format]) # GOOD
    fmt = "%s"
    printf(fmt, params[:format]) # GOOD

    printf(IO.new(1), params[:format]) # GOOD [FALSE POSITIVE]
    Kernel.printf(IO.new(1), params[:format]) # GOOD [FALSE POSITIVE]
    
    str1 = Kernel.sprintf(params[:format], arg) # BAD
    str2 = sprintf(params[:format], arg) # BAD

    str1 = Kernel.sprintf(params[:format]) # GOOD
    str2 = sprintf(params[:format]) # GOOD
    
    stdout = IO.new 1
    stdout.printf(params[:format], arg) # BAD

    stdout.printf(params[:format]) # GOOD
    
    # Taint via string concatenation
    printf("A log message: " + params[:format], arg) # BAD

    # Taint via string interpolation
    printf("A log message: #{params[:format]}", arg) # BAD
  end
end