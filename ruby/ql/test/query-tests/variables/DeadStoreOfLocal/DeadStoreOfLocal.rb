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

