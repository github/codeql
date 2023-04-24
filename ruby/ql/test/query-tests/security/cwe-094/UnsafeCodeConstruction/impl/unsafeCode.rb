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
    eval("def \n #{code} \n end") # OK - parameter is named code
  end

  def joinStuff(my_arr)
    eval(my_arr.join("\n")) # NOT OK
  end

  def joinWithElemt(x) 
    arr = [x, "foobar"]
    eval(arr.join("\n")) # NOT OK
  end

  def pushArr(x, y)
    arr = []
    arr.push(x)
    eval(arr.join("\n")) # NOT OK

    arr2 = []
    arr2 << y
    eval(arr.join("\n")) # NOT OK
  end

  def hereDoc(x)
    foo = <<~HERE
        #{x}
    HERE
    eval(foo) # NOT OK
  end

  def string_concat(x)
    foo = "foo = " + x
    eval(foo) # NOT OK
  end

  def join_indirect(x, y) 
    arr = Array(x)
    eval(arr.join(" ")) # NOT OK

    arr2 = [Array(["foo = ", y]).join(" ")]
    eval(arr2.join("\n")) # NOT OK
  end
end
