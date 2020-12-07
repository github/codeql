def m1 x
  if x > 2
    puts "x is greater than 2"
  elsif x <= 2 and x > 0 and !(x == 5)
    puts "x is 1"
  else
    puts "I can't guess the number"
  end
end

def m2 b
  if b
    return 0
  end
  return 1
end

def m3 x
  if x < 0
    x = -x
    if x > 10
      x = x - 1
    end
  end
  puts x
end

def m4 (b1, b2, b3)
  return (b1 ? b2 : b3) ? "b2 || b3" : "!b2 || !b3"
end