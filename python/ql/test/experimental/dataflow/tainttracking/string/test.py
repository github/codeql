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
        bytes(ts),
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


def percent_fmt():
    print("\n#percent_fmt")
    ts = TAINTED_STRING
    tainted_fmt = ts + " %s %s"
    ensure_tainted(
        tainted_fmt % (1, 2),
        "%s foo bar" % ts,
        "%s %s %s" % (1, 2, ts),
    )


def binary_decode_encode():
    print("\n#percent_fmt")
    tb = TAINTED_BYTES
    import base64

    ensure_tainted(
        base64.b64encode(tb),
        base64.b64decode(base64.b64encode(tb)),

        base64.standard_b64encode(tb),
        base64.standard_b64decode(base64.standard_b64encode(tb)),

        base64.urlsafe_b64encode(tb),
        base64.urlsafe_b64decode(base64.urlsafe_b64encode(tb)),

        base64.b32encode(tb),
        base64.b32decode(base64.b32encode(tb)),

        base64.b16encode(tb),
        base64.b16decode(base64.b16encode(tb)),

        # # New in Python 3.4
        # base64.a85encode(tb),
        # base64.a85decode(base64.a85encode(tb)),

        # # New in Python 3.4
        # base64.b85encode(tb),
        # base64.b85decode(base64.b85encode(tb)),

        # # New in Python 3.1
        # base64.encodebytes(tb),
        # base64.decodebytes(base64.encodebytes(tb)),

        # deprecated since Python 3.1, but still works
        base64.encodestring(tb),
        base64.decodestring(base64.encodestring(tb)),
    )

    import quopri
    ensure_tainted(
        quopri.encodestring(tb),
        quopri.decodestring(quopri.encodestring(tb)),
    )


# Make tests runable

str_operations()
str_methods()
non_syntactic()
percent_fmt()
binary_decode_encode()
