def test_basic
    puts x  #$ MISSING: Alert
end

def test_nil
    x = foo.nil? #$ MISSING: Alert
    puts x
end

def test_condition
    if x  #$ MISSING: Alert
        puts x #$ MISSING: Alert
    end
end

def test_nested_condition
    if (x = 4 || x)  #$ SPURIOUS: Alert
        puts x
    end
end

def test_conditional_assignment
    if false
        status = i  #$ MISSING: Alert
    end
    puts status  #$ SPURIOUS: Alert
    puts i  #$ MISSING: Alert
end

def get
    raise SyntaxError
end
  
def test_rescue_ensure
    a = get()
    b = c + 2  #$ MISSING: Alert
rescue SyntaxError
    puts "rescue"
    puts a  #$ SPURIOUS: Alert
    puts b  #$ SPURIOUS: Alert
    puts c  #$ MISSING: Alert
    puts "rescue end"
ensure
    puts "ensure"
    puts a  #$ SPURIOUS: Alert
    puts b  #$ SPURIOUS: Alert
    puts c  #$ MISSING: Alert
    puts "the end"
end