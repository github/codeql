def foo_source():
    return 'foo'


def foo_sink(x):
    if x == 'foo':
        print('fire the foo missiles')


def bar_sink(x):
    if x == 'bar':
        print('fire the bar missiles')


def should_report():
    x = foo_source()
    foo_sink(x)


def should_not_report():
    x = foo_source()
    bar_sink(x)
