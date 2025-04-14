import urllib.parse

def test():
    ts = TAINTED_STRING

    params = urllib.parse.parse_qs(ts)

    ensure_tainted(
        params, # $ tainted
    )
