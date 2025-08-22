def foo(foo_x):  # $tracked
    print("foo", foo_x)  # $tracked


def bar(bar_x):  # $tracked
    print("bar", bar_x)  # $tracked


if len(__file__) % 2 == 0:
    f = foo
else:
    f = bar

x = tracked  # $tracked
f(x)  # $tracked
