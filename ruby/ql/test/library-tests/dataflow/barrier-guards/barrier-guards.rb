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
