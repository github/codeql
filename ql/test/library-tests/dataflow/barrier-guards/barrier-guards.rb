foo = "foo"

if foo == "foo"
    do_true foo
else
    do_false foo
end

if ["foo"].include?(foo)
    do_true foo
else
    do_false foo
end

if foo != "foo"
    do_true foo
else
    do_false foo
end

do_default foo

