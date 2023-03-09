def normal_helper(arg):
    l = [arg]
    return l[0]

# we had a regression where flow from a source to the argument of this function would
# cause _all_ returns from this function to be treated as tainted. That is, the
# `generator_helper(NONSOURCE)` call in `test_non_source` would result in taint :| This
# is specific to taint-tracking, and does NOT appear in pure data-flow (see the
# test_dataflow file)
def generator_helper(arg):
    l = [arg]
    l = [x for x in l]
    return l[0]


def generator_helper_wo_source_use(arg):
    l = [arg]
    l = [x for x in l]
    return l[0]

def test_source():
    x = normal_helper(TAINTED_STRING)
    ensure_tainted(x) # $ tainted

    x = generator_helper(TAINTED_STRING)
    ensure_tainted(x) # $ tainted


def test_non_source():
    x = normal_helper(NONSOURCE)
    ensure_not_tainted(x)

    x = generator_helper(NONSOURCE)
    ensure_not_tainted(x)

    x = generator_helper_wo_source_use(NONSOURCE)
    ensure_not_tainted(x)
