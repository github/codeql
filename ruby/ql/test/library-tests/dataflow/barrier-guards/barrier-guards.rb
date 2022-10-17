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

if foos.index(foo) == nil
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

if x or y then
    foo
else
    bars
end

if x and y then
    foo
else
    bars
end

if not x then
    foo
else
    bars
end

case foo
when "foo"
    foo
else
    foo
end

case foo
when "foo"
    foo
when "bar"
    foo
end

case foo
when "foo", "bar" # not recognised
    foo
when "baz", "quux" # not recognised
    foo
else
    foo
end

case foo
when *["foo", "bar"]
    foo
end

case foo
when *%w[foo bar]
    foo
end

case foo
when *FOO
    foo
end

case foo
when *foos
    foo
end

case foo
when *["foo", x] # not a guard - includes non-constant element `x`
    foo
end

case foo
when "foo", x # not a guard - includes non-constant element `x`
    foo
end

foo_and_x = ["foo", x]

case foo
when *foo_and_x # not a guard - includes non-constant element `x`
    foo
end

FOO_AND_X = ["foo", x]

case foo
when *FOO_AND_X # not a guard - includes non-constant element `x`
    foo
end

if foo == "foo" or foo == "bar" # not recognised
    foo
end
