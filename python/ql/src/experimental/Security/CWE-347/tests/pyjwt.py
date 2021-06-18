import jwt

# Encoding

# good - key and algorithm supplied
jwt.encode({"foo": "bar"}, "key", "HS256")
jwt.encode({"foo": "bar"}, key="key", algorithm="HS256")

# bad - both key and algorithm set to None
jwt.encode({"foo": "bar"}, None, None)

# bad - empty key
jwt.encode({"foo": "bar"}, "", algorithm="HS256")
jwt.encode({"foo": "bar"}, key="", algorithm="HS256")

# Decoding

# good
jwt.decode(token, "key", "HS256")

# bad - unverified decoding
jwt.decode(token, verify=False)
jwt.decode(token, key, options={"verify_signature": False})

# good - verified decoding
jwt.decode(token, verify=True)
jwt.decode(token, key, options={"verify_signature": True})
