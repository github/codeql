class Foobar
  def foo1(target) # $ Source
    IO.popen("cat #{target}", "w") # $ Alert // NOT OK - everything assumed to be imported...
  end
end
