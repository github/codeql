class ExceptionA < Exception
end
  
class ExceptionB < Exception
end

def m1 x
  if x > 2
    raise "x > 2"
  end
  puts "x <= 2"
end

def m2 b
  begin
    if b
      raise ExceptionA
    end
  rescue ExceptionA
    puts "Rescued"
  end
  puts "End m2"
end

def m3 b
  begin
    if b
      raise ExceptionA
    end
  rescue
    puts "Rescued"
  end
  puts "End m3"
end

def m4 b
  begin
    if b
      raise ExceptionA
    end
  rescue => e
    puts "Rescued {e}"
  end
  puts "End m4"
end

def m5 b
  begin
    if b
      raise ExceptionA
    end
  rescue => e
  end
  puts "End m5"
end

def m6 b
  begin
    if b
      raise ExceptionA
    end
  rescue ExceptionA, ExceptionB => e
    puts "Rescued {e}"
  end
  puts "End m6"
end

def m7 x
  if x > 2
    raise "x > 2"
  elsif x < 0
    return "x < 0"
  end
  puts "0 <= x <= 2"
ensure
  puts "ensure"
end

def m8 x
  puts "Begin m8"
  begin
    if x > 2
      raise "x > 2"
    elsif x < 0
      return "x < 0"
    end
    puts "0 <= x <= 2"
  ensure
    puts "ensure"
  end
  puts "End m8"
end

def m9(x, b1, b2)
  puts "Begin m9"
  begin
    if x > 2
      raise "x > 2"
    elsif x < 0
      return "x < 0"
    end
    puts "0 <= x <= 2"
  ensure
    puts "outer ensure"
    begin
      if b1
        raise "b1 is true"
      end      
    ensure
      puts "inner ensure"
    end
  end
  puts "End m9"
ensure
  puts "method ensure"
  if b2
    raise "b2 is true"
  end
end

def m10(p = (raise "Exception"))
rescue
  puts "Will not get executed if p is not supplied"
ensure
  puts "Will not get executed if p is not supplied"
end

def m11 b
  begin
    if b
      raise ExceptionA
    end
  rescue ExceptionA
  rescue ExceptionB
    puts "ExceptionB"
  ensure
    puts "Ensure"
  end
  puts "End m11"
end

def m12 b
  if b
    raise ""
  end
ensure
  return 3
end

def m13
ensure
end

def m14 element
  element.each { |elem| raise "" if element.nil? }
end

def m15
  foo do
    bar ->(x) do
      raise "" unless x
    end
  end
end

class C
  def self.m()
    raise ""
  end
end
