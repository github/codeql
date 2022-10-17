class Foobar
  def foo1(target)
    eval("foo = #{target}") # NOT OK
  end

  # sprintf
  def foo2(x) 
    eval(sprintf("foo = %s", x)) # NOT OK
  end

  # String#%
  def foo3(x)
    eval("foo = %{foo}" % {foo: x}) # NOT OK
  end   

  def indirect_eval(x)
    eval(x) # OK - no construction.
  end
end
