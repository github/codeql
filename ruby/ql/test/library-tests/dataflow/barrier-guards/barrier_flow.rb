def m1
    x = source(1)

    sink x # $ hasValueFlow=1
end

def m2
    x = source(2)

    if x != "safe" then
        sink x # $ hasValueFlow=2
    end
end

def m3
    x = source(3)

    if x == "safe" then
        sink x # $ guarded
    end
end

def m4
    x = source(4)

    sink x unless x == "safe" # $ hasValueFlow=4
end

def m5
    x = source(5)

    sink x unless x != "safe" # $ guarded
end

def m6
    x = source(6)

    if x != "safe" then
        x = "safe"
    end

    sink x
end

def m7
    x = source(7)

    x = "safe" unless x == "safe"

    sink x
end

def m8(b)
    x = source(8)

    if b then
        return unless x == "safe1"
    else
        return unless x == "safe2"
    end

    sink x
end

def m9(b)
    x = source(9)

    if b then
        if x != "safe1" then
            return
        end
    else
        if x != "safe2" then
            return
        end
    end

    sink x
end
