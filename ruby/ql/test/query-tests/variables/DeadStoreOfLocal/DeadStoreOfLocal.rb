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

def do_twice
    yield
    yield
end
    
def get_done_twice x
    do_twice do
        print x
        x += 1  # OK - the block is executed twice
    end
end

def retry_once
    yield
rescue
    yield
end
    
def get_retried x
    retry_once do
        print x
        if x < 1
            begin
                x += 1  #$ SPURIOUS: Alert
                raise StandardError
            end
        end
    end
end