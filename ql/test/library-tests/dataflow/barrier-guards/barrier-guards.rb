foo = "foo"

if foo == "foo"
    do_true_1 foo
else
    do_false_1 foo
end

if ["foo"].include?(foo)
    do_true_2 foo
else
    do_false_2 foo
end

do_default foo

