# Bad interaction of two summaries for the same function
ts = TAINTED_STRING

from extracted_package.functions import with_subpath, without_subpath

# For the function `with_subpath`, flow from the first argument to the return value
# can be concluded from its definition. This seems to discard all summaries, including
# the one with flow to `ReturnValue.Attribute[pattern]`.
ensure_tainted(
    with_subpath(ts).pattern,  # $ tainted
    with_subpath(ts),  # $ tainted
    with_subpath(ts),  # $ tainted
)
ensure_tainted(
    without_subpath(ts).pattern,  # $ tainted
    without_subpath(ts),  # $ tainted
    without_subpath(ts),  # $ tainted
)