from jose import jwt

# Encoding

# good - key and algorithm supplied
jwt.encode(token, "key", "HS256")
jwt.encode(token, key="key", algorithm="HS256")

# bad - empty key
jwt.encode(token, "", algorithm="HS256")
jwt.encode(token, key="", algorithm="HS256")

# Decoding

# good
jwt.decode(token, "key", "HS256")

# bad - unverified decoding
jwt.decode(token, key, options={"verify_signature": False})

# good - verified decoding
jwt.decode(token, key, options={"verify_signature": True})
