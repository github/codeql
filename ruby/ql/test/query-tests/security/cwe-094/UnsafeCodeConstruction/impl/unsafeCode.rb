class Foobar
  def foo1(target) # $ Source
    eval("foo = #{target}") # $ Alert // NOT OK
  end

  # sprintf
  def foo2(x)  # $ Source
    eval(sprintf("foo = %s", x)) # $ Alert // NOT OK
  end

  # String#%
  def foo3(x) # $ Source
    eval("foo = %{foo}" % {foo: x}) # $ Alert // NOT OK
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

  def joinStuff(my_arr) # $ Source
    eval(my_arr.join("\n")) # $ Alert // NOT OK
  end

  def joinWithElemt(x)  # $ Source
    arr = [x, "foobar"]
    eval(arr.join("\n")) # $ Alert // NOT OK
  end

  def pushArr(x, y) # $ Source
    arr = []
    arr.push(x)
    eval(arr.join("\n")) # $ Alert // NOT OK

    arr2 = []
    arr2 << y
    eval(arr.join("\n")) # $ Alert // NOT OK
  end

  def hereDoc(x) # $ Source
    foo = <<~HERE
        #{x} #{# $ Alert
}
    HERE
    eval(foo) # NOT OK
  end

  def string_concat(x) # $ Source
    foo = "foo = " + x # $ Alert
    eval(foo) # NOT OK
  end

  def join_indirect(x, y)  # $ Source
    arr = Array(x)
    eval(arr.join(" ")) # $ Alert // NOT OK

    arr2 = [Array(["foo = ", y]).join(" ")]
    eval(arr2.join("\n")) # $ Alert // NOT OK
  end
end
