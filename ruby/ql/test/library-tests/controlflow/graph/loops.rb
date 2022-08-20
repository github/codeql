def m1 x
  while x >= 0
    puts x
    x -= 1
  end
end

def m2 x
  while x >= 0
    puts x
    x -= 1
    if x > 100
      break
    elsif x > 50
      next
    elsif x > 10
      redo
    end
    puts "Iter"
  end
  puts "Done"
end

def m3
  [1,2,3].each do |x|
    puts x
  end
end

def m4(x, y)
  while x < y do
  end
end
