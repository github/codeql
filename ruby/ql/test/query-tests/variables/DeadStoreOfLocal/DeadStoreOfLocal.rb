def test_basic(x)
    y = x  #$ Alert
    y = x + 2
    return y
end

def test_retry
    x = 0
    begin
        if x == 0
            raise "error"
        end
    rescue
        x = 2  # OK - the retry will allow a later read
        retry
    end
    return 42
end

def test_binding
    x = 4  # OK - the binding collects the value of x
    return binding
end

class Sup
    def m(x)
        print(x + 1)
    end
end
  
class Sub < Sup
    def m(y)
        y = 3  # OK - the call to `super` sees the value of `y``
        super
    end
end