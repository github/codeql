import simplejson
from io import StringIO

def test():
    ts = TAINTED_STRING
    tainted_obj = {"foo": ts}

    encoded = simplejson.dumps(tainted_obj) # $ encodeOutput=simplejson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj

    ensure_tainted(
        encoded, # $ tainted
        simplejson.dumps(tainted_obj), # $ tainted encodeOutput=simplejson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj
        simplejson.dumps(obj=tainted_obj), # $ tainted encodeOutput=simplejson.dumps(..) encodeFormat=JSON encodeInput=tainted_obj
        simplejson.loads(encoded), # $ tainted decodeOutput=simplejson.loads(..) decodeFormat=JSON decodeInput=encoded
        simplejson.loads(s=encoded), # $ tainted decodeOutput=simplejson.loads(..) decodeFormat=JSON decodeInput=encoded
    )

    # load/dump with file-like
    tainted_filelike = StringIO()
    simplejson.dump(tainted_obj, tainted_filelike) # $ encodeFormat=JSON encodeInput=tainted_obj encodeOutput=[post]tainted_filelike

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ tainted
        simplejson.load(tainted_filelike), # $ tainted decodeOutput=simplejson.load(..) decodeFormat=JSON decodeInput=tainted_filelike
    )

    # load/dump with file-like using keyword-args
    tainted_filelike = StringIO()
    simplejson.dump(obj=tainted_obj, fp=tainted_filelike) # $ encodeFormat=JSON encodeInput=tainted_obj encodeOutput=[post]tainted_filelike

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ tainted
        simplejson.load(fp=tainted_filelike), # $ tainted decodeOutput=simplejson.load(..) decodeFormat=JSON decodeInput=tainted_filelike
    )

# To make things runable

TAINTED_STRING = "TAINTED_STRING"
def ensure_tainted(*args):
    print("- ensure_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))

test()
