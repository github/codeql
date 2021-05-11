from io import StringIO
import json

def test():
    print("\n# test")
    ts = TAINTED_STRING

    encoded = json.dumps(ts) # $ encodeOutput=json.dumps(..) encodeFormat=JSON encodeInput=ts

    ensure_tainted(
        encoded, # $ tainted
        json.dumps(ts), # $ tainted encodeOutput=json.dumps(..) encodeFormat=JSON encodeInput=ts
        json.dumps(obj=ts), # $ tainted encodeOutput=json.dumps(..) encodeFormat=JSON encodeInput=ts
        json.loads(encoded), # $ tainted decodeOutput=json.loads(..) decodeFormat=JSON decodeInput=encoded
        json.loads(s=encoded), # $ tainted decodeOutput=json.loads(..) decodeFormat=JSON decodeInput=encoded
    )

    # load/dump with file-like
    tainted_filelike = StringIO()
    json.dump(ts, tainted_filelike) # $ encodeOutput=[post]tainted_filelike encodeFormat=JSON encodeInput=ts

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ tainted
        json.load(tainted_filelike), # $ tainted decodeOutput=json.load(..) decodeFormat=JSON decodeInput=tainted_filelike
    )

    # load/dump with file-like using keyword-args
    tainted_filelike = StringIO()
    json.dump(obj=ts, fp=tainted_filelike) # $ encodeOutput=[post]tainted_filelike encodeFormat=JSON encodeInput=ts

    tainted_filelike.seek(0)
    ensure_tainted(
        tainted_filelike, # $ tainted
        json.load(fp=tainted_filelike), # $ tainted decodeOutput=json.load(..) decodeFormat=JSON decodeInput=tainted_filelike
    )


# Make tests runable
test()
