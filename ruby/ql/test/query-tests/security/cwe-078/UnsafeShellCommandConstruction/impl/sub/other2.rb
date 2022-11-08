class Foobar
  def foo1(target)
    IO.popen("cat #{target}", "w") # NOT OK
  end
end