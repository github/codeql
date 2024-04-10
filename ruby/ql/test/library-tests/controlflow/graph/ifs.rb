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

def m5 (b1, b2, b3, b4, b5)
  if (if b1 then b2 elsif b3 then b4 else b5 end) then "b2 || b4 || b5" else "!b2 || !b4 || !b5" end
end

def conditional_method_def()
  puts "bla"
end unless 1 == 2

def constant_condition()
  if !true
    puts "Impossible"
  end
end

def empty_else b
  if b then
    puts "true"
  else
  end
  puts "done"
end

def disjunct (b1, b2)
  if (b1 || b2) then
    puts "b1 or b2"
  end
end
