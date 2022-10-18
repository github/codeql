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

  def send_stuff(x)
    foo.send("foo_#{x}") # OK - attacker cannot control entire string.
  end

  def named_code(code)
    foo.send("def \n #{code} \n end") # OK - parameter is named code
  end
end
