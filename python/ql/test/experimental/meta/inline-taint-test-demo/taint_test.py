def expected_usage():
    ts = TAINTED_STRING

    # simulating handling something we _want_ to treat at tainted, but we currently treat as untainted
    should_be_tainted = "pretend this is unsafe"

    ensure_tainted(
        ts, # $ tainted
        should_be_tainted, # $ MISSING: tainted
    )

    # having one annotation for multiple arguments is OK, as long as all arguments
    # fulfil the same annotation
    ensure_tainted(ts, ts) # $ tainted

    # simulating handling something we _want_ to treat at untainted, but we currently treat as tainted
    should_not_be_tainted = "pretend this is now safe" + ts
    ensure_not_tainted(
        should_not_be_tainted, # $ SPURIOUS: tainted
        "FOO"
    )


def bad_usage():
    ts = TAINTED_STRING

    # simulating handling something we _want_ to treat at tainted, but we currently treat as untainted
    should_be_tainted = "pretend this is unsafe"

    # This element _should_ have a `$ MISSING: tainted` annotation, which will be alerted in the .expected output
    ensure_tainted(
        should_be_tainted,
    )

    # using one annotation for multiple arguments i not OK when it's mixed whether our
    # taint-tracking works as expected
    ensure_tainted(ts, should_be_tainted) # $ tainted

    # if you try to get around it by adding BOTH annotations, that results in a problem
    # from the default set of inline-test-expectation rules
    ensure_tainted(ts, should_be_tainted) # $ tainted MISSING: tainted

    # simulating handling something we _want_ to treat at untainted, but we currently treat as tainted
    should_not_be_tainted = "pretend this is now safe" + ts

    # This annotation _should_ have used `SPURIOUS`, which will be alerted on in the .expected output
    ensure_not_tainted(
        should_not_be_tainted # $ tainted
    )
