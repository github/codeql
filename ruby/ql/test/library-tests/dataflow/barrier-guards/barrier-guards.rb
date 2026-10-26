foo = "foo"

if foo == "foo"
    foo # $ guarded
else
    foo
end

if ["foo"].include?(foo)
    foo # $ guarded
else
    foo
end

if foo != "foo"
    foo
else
    foo # $ guarded
end

unless foo == "foo"
    foo
else
    foo # $ guarded
end

unless foo != "foo"
    foo # $ guarded
else
    foo
end

foo

FOO = ["foo"]

if FOO.include?(foo)
    foo # $ guarded
else
    foo
end

if foo == "foo"
    capture {
        foo # $ guarded
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
    foo # $ guarded
else
    foo
end

if bars.include?(foo)
    foo
else
    foo
end

if foos.index(foo) != nil
    foo # $ guarded
else
    foo
end

if foos.index(foo) == nil
    foo
else
    foo # $ guarded
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
    foo # $ guarded
else
    foo
end

case foo
when "foo"
    foo # $ guarded
when "bar"
    foo # $ guarded
end

case foo
when "foo", "bar"
    foo # $ guarded
when "baz", "quux"
    foo # $ guarded
else
    foo
end

case foo
when *["foo", "bar"]
    foo # $ guarded
end

case foo
when *%w[foo bar]
    foo # $ guarded
end

case foo
when *FOO
    foo # $ guarded
end

case foo
when *foos
    foo # $ guarded
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

if foo == "foo" or foo == "bar"
    foo # $ guarded
end

if foo == "foo" or foo == "bar" or foo == "baz"
    foo # $ guarded
end

if foo == "foo" or foo == "bar" or foo == x
    foo
end

if foo == "foo" or bar == "bar" or foo == "baz"
    foo
end

if foo == "foo" and x
    foo # $ guarded
end

if x and foo == "foo"
    foo # $ guarded
end

if x and y and foo == "foo"
    foo # $ guarded
end

if foo == "foo" and foo == "bar" # $ guarded (second `foo` is guarded by the first comparison)
    foo # $ guarded
end

if x and y
    foo
end

if foo == "foo" and y
    bar
end

case
when foo == "foo"
    foo # $ guarded
end

case
when foo == "foo" then foo # $ guarded
when bar == "bar" then foo
when foo == x then foo
end

case foo
in "foo"
    foo # $ guarded
in x
    foo
end

case bar
in "foo"
    foo
end

if foo == "#{some_method()}"
    foo
end

F = "foo"
if foo == "#{F}"
    foo # $ guarded
end

f = "foo"
if foo == "#{f}"
    foo # $ guarded
end

if foo == "#{f}#{unknown_var}"
    foo
end

foo == "foo" && foo # $ guarded
foo && foo == "foo"

if [f].include? foo
    foo # $ guarded
end

g = "g"
foos = [f, g]
if foos.include? foo
    foo # $ guarded
end

foos = [f, g, some_method_call]
if foos.include? foo
    foo
end

case foo
when g
    foo # $ guarded
else
    foo
end