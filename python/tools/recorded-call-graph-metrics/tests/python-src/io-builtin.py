import io

# the `io.open` is just an alias for `_io.open`, but we record the external callee as `io.open` :|
io.open("foo")
