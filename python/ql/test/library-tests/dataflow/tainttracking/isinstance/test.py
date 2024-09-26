def impossible_flow(cond: bool):
    TAINTED_STRING = "ts"
    x = (TAINTED_STRING, 42) if cond else "SAFE"

    if isinstance(x, str):
        # tainted-flow to here is impossible, replicated from path-flow seen in a real
        # repo.
        ensure_not_tainted(x)
        ensure_not_tainted_with_reads(x) # $ SPURIOUS:tainted
    else:
        ensure_not_tainted(x)
        ensure_tainted(x[0]) # $ tainted
        ensure_tainted_with_reads(x) # $ tainted
