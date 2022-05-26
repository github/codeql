import ujson
from io import StringIO

def test():
    ts = TAINTED_STRING
    tainted_obj = {"foo": ts}

    encoded = ujson.dumps(tainted_obj) # $ encodeOutput=ujson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj

    ensure_tainted(
        encoded, # $ tainted
        ujson.dumps(tainted_obj), # $ tainted encodeOutput=ujson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj
        ujson.dumps(obj=tainted_obj), # $ tainted encodeOutput=ujson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj
        ujson.loads(encoded), # $ tainted decodeOutput=ujson.loads(..) decodeFormat=JSON decodeInput=encoded
        ujson.loads(obj=encoded), # $ tainted decodeOutput=ujson.loads(..) decodeFormat=JSON decodeInput=encoded

        ujson.encode(tainted_obj), # $ tainted encodeOutput=ujson.encode(..) encodeFormat=JSON encodeInput=tainted_obj
        ujson.encode(obj=tainted_obj), # $ tainted encodeOutput=ujson.encode(..) encodeFormat=JSON encodeInput=tainted_obj
        ujson.decode(encoded), # $ tainted decodeOutput=ujson.decode(..) decodeFormat=JSON decodeInput=encoded
        ujson.decode(obj=encoded), # $ tainted decodeOutput=ujson.decode(..) decodeFormat=JSON decodeInput=encoded
    )

    # load/dump with file-like
    tainted_filelike = StringIO()
    ujson.dump(tainted_obj, tainted_filelike) # $ encodeFormat=JSON encodeInput=tainted_obj encodeOutput=[post]tainted_filelike

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ tainted
        ujson.load(tainted_filelike), # $ tainted decodeOutput=ujson.load(..) decodeFormat=JSON decodeInput=tainted_filelike
    )

    # load/dump with file-like using keyword-args does not work in `ujson`


# To make things runable

TAINTED_STRING = "TAINTED_STRING"
def ensure_tainted(*args):
    print("- ensure_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))

test()
