class Foobar
  def foo1(target) # $ Source
    IO.popen("cat #{target}", "w") # $ Alert // NOT OK
  end
end
