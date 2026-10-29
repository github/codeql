from io import StringIO, BytesIO

TAINTED_STRING = "TS"
TAINTED_BYTES = b"TB"

def ensure_tainted(*args):
    print("ensure_tainted")
    for arg in args:
        print("", repr(arg))


def test_stringio():
    ts = TAINTED_STRING

    x = StringIO()
    x.write(ts)
    x.seek(0)

    ensure_tainted(
        StringIO(ts), # $ tainted
        StringIO(initial_value=ts), # $ tainted
        x, # $ tainted

        x.read(), # $ tainted
        StringIO(ts).read(), # $ tainted
    )


def test_bytesio():
    tb = TAINTED_BYTES

    x = BytesIO()
    x.write(tb)
    x.seek(0)

    ensure_tainted(
        BytesIO(tb), # $ tainted
        BytesIO(initial_bytes=tb), # $ tainted
        x, # $ tainted

        x.read(), # $ tainted
        BytesIO(tb).read(), # $ tainted
    )


test_stringio()
test_bytesio()
