# Python 3 specific taint tracking for string

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

def str_methods():
    print("\n# str_methods")
    ts = TAINTED_STRING
    tb = TAINTED_BYTES
    ensure_tainted(
        ts.casefold(),

        ts.format_map({}),
        "{unsafe}".format_map({"unsafe": ts}),
    )


def binary_decode_encode():
    print("\n#percent_fmt")
    tb = TAINTED_BYTES
    import base64

    ensure_tainted(
        # New in Python 3.4
        base64.a85encode(tb),
        base64.a85decode(base64.a85encode(tb)),

        # New in Python 3.4
        base64.b85encode(tb),
        base64.b85decode(base64.b85encode(tb)),

        # New in Python 3.1
        base64.encodebytes(tb),
        base64.decodebytes(base64.encodebytes(tb)),
    )


def f_strings():
    print("\n#f_strings")
    ts = TAINTED_STRING

    ensure_tainted(f"foo {ts} bar")


# Make tests runable

str_methods()
binary_decode_encode()
f_strings()
