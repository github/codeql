def m1 elements
  for element in elements do
    if element > 0 then
      break
    end
  end
ensure
  if elements.nil? then
    puts "elements nil"
  end
end

def m2 elements
  for element in elements do
    begin
      if element > 0 then
        break
      end
    ensure
      if elements.nil? then
        puts "elements nil"
      end
    end
  end
end

def m3 elements
  begin
    if elements.nil? then
      return
    end
  ensure
    for element in elements do
      begin
        if x > 0 then
          break
        end
      end
    end
  end
  puts "Done"
end

def m4 elements
  for element in elements do
    begin
      if element > 1 then
        raise ""
      end
    ensure
      if element > 0 then
        break 10;
      end
    end
  end
end
