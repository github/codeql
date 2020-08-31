def fstring():
    tainted_string = TAINTED_STRING
    ensure_tainted(
        f"foo {tainted_string} bar"
    )
