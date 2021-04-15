def expected_usage():
    ts = TAINTED_STRING

    # simulating handling something we _want_ to treat at tainted, but we currently treat as untainted
    should_be_tainted = "pretend this is unsafe"

    ensure_tainted(
        ts, # $ tainted
        should_be_tainted, # $ MISSING: tainted
    )

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

    # simulating handling something we _want_ to treat at untainted, but we currently treat as tainted
    should_not_be_tainted = "pretend this is now safe" + ts

    # This annotation _should_ have used `SPURIOUS`, which will be alerted on in the .expected output
    ensure_not_tainted(
        should_not_be_tainted # $ tainted
    )
