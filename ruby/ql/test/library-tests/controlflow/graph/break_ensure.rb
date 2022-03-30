def m1 x
  while x < 0
    if x > 0 then
      break
    end
  end
ensure
  if elements.nil? then
    puts "elements nil"
  end
end

def m2(x, y)
  while x < 0
    begin
      if x > 0 then
        break
      end
    ensure
      if y.nil? then
        puts "y nil"
      end
    end
  end
end

def m3(x,y)
  begin
    if x.nil? then
      return
    end
  ensure
    while y < 0
      begin
        if x > 0 then
          break
        end
      end
    end
  end
  puts "Done"
end

def m4 x
  while x < 0
    begin
      if x > 1 then
        raise ""
      end
    ensure
      if x > 0 then
        break 10;
      end
    end
  end
end
