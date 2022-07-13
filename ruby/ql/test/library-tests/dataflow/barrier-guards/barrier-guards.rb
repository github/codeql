foo = "foo"

if foo == "foo"
    foo
else
    foo
end

if ["foo"].include?(foo)
    foo
else
    foo
end

if foo != "foo"
    foo
else
    foo
end

unless foo == "foo"
    foo
else
    foo
end

unless foo != "foo"
    foo
else
    foo
end

foo

FOO = ["foo"]

if FOO.include?(foo)
    foo
else
    foo
end

if foo == "foo"
    capture {
        foo # guarded
    }
end

if foo == "foo"
    capture {
        foo = "bar"
        foo # not guarded
    }
end

if foo == "foo"
    my_lambda = -> () {
        foo # not guarded
    }

    foo = "bar"

    my_lambda()
end

foos = nil
foos = ["foo"]
bars = NotAnArray.new

if foos.include?(foo)
    foo
else
    foo
end

if bars.include?(foo)
    foo
else
    foo
end

if foos.index(foo) != nil
    foo
else
    foo
end

if foos.index(foo)r == nil
    foo
else
    foo
end

bars = ["bar"]

if condition
    bars = nil
end

if bars.include?(foo)
    foo
else
    foo
end
