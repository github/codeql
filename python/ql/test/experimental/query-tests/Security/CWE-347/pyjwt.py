import jwt

# Encoding

# good - key and algorithm supplied
jwt.encode(token, "key", "HS256")
jwt.encode(token, key="key", algorithm="HS256")

# bad - both key and algorithm set to None
jwt.encode(token, None, None)

# bad - empty key
jwt.encode(token, "", algorithm="HS256")
jwt.encode(token, key="", algorithm="HS256")

# Decoding

# good
jwt.decode(token, "key", "HS256")

# bad - unverified decoding
jwt.decode(token, verify=False)
jwt.decode(token, key, options={"verify_signature": False})

# good - verified decoding
jwt.decode(token, verify=True)
jwt.decode(token, key, options={"verify_signature": True})


def indeterminate(verify):
    jwt.decode(token, key, verify)
