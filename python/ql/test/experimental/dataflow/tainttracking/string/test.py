TAINTED_STRING = "TAINTED_STRING"
TAINTED_BYTES = b"TAINTED_BYTES"


def ensure_tainted(*args):
    print("- ensure_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))


def ensure_not_tainted(*args):
    print("- ensure_not_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))


# Actual tests


def str_operations():
    print("\n# str_operations")
    ts = TAINTED_STRING
    ensure_tainted(
        ts,
        ts + "foo",
        "foo" + ts,
        ts[0 : len(ts)],
        ts[:],
        ts[0:1000],
        ts[0],
        str(ts),
    )


def str_methods():
    print("\n# str_methods")
    ts = TAINTED_STRING
    tb = TAINTED_BYTES
    ensure_tainted(
        ts.capitalize(),
        ts.casefold(),
        ts.center(100),
        ts.expandtabs(),

        ts.format(),
        "{}".format(ts),
        "{unsafe}".format(unsafe=ts),

        ts.format_map({}),
        "{unsafe}".format_map({"unsafe": ts}),

        ts.join(["", ""]),
        "".join([ts]),

        ts.ljust(100),
        ts.lstrip(),
        ts.lower(),

        ts.replace("old", "new"),
        "safe".replace("safe", ts),

        ts.rjust(100),
        ts.rstrip(),
        ts.strip(),
        ts.swapcase(),
        ts.title(),
        ts.upper(),
        ts.zfill(100),

        ts.encode("utf-8"),
        ts.encode("utf-8").decode("utf-8"),

        tb.decode("utf-8"),
        tb.decode("utf-8").encode("utf-8"),

        # string methods that return a list
        ts.partition("_"),
        ts.rpartition("_"),
        ts.rsplit("_"),
        ts.split("_"),
        ts.splitlines(),
    )

    ensure_not_tainted(
        # Intuitively I think this should be safe, but better discuss it
        "safe".replace(ts, "also-safe"),

        ts.join([]),  # FP due to separator not being used with zero/one elements
        ts.join(["safe"]),  # FP due to separator not being used with zero/one elements
    )


def non_syntactic():
    print("\n# non_syntactic")
    ts = TAINTED_STRING
    meth = ts.upper
    _str = str
    ensure_tainted(
        meth(),
        _str(ts),
    )

# Make tests runable

str_operations()
str_methods()
non_syntactic()
