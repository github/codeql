def m1 x
  if x > 2
    exit 1
  end
  puts "x <= 2"
end

def m2 x
  if x > 2
    abort "abort!"
  end
  puts "x <= 2"
end
