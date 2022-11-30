def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

def m1
    a = Array.new
    if rand() > 0 then
        a[0] = taint(1)
    else
        a = nil
    end
    sink(a[0]) # $ hasValueFlow=1
end

m1

def m2
    a = Array.new
    if rand() > 0 then
        a[0] = taint(2)
        a.clear
    else
        a = nil
    end
    sink(a[0])
end

m2
