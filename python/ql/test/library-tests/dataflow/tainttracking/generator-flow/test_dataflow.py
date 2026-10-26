def normal_helper(arg):
    l = [arg]
    return l[0]


def generator_helper(arg):
    l = [arg]
    l = [x for x in l]
    return l[0]


def generator_helper_wo_source_use(arg):
    l = [arg]
    l = [x for x in l]
    return l[0]


def test_source():
    x = normal_helper(SOURCE)
    SINK(x) # $ flow="SOURCE, l:-1 -> x"

    x = generator_helper(SOURCE)
    SINK(x) # $ flow="SOURCE, l:-1 -> x"


def test_non_source():
    x = normal_helper(NONSOURCE)
    SINK_F(x)

    x = generator_helper(NONSOURCE)
    SINK_F(x)

    x = generator_helper_wo_source_use(NONSOURCE)
    SINK_F(x)
