from authlib.jose import jwt  # It is already a JsonWebToken object
from authlib.jose import JsonWebToken

# Encoding

# good - key and algorithm supplied
jwt.encode({"alg": "HS256"}, token, "key")
JsonWebToken().encode({"alg": "HS256"}, token, "key")

# bad - empty key
jwt.encode({"alg": "HS256"}, token, "")
JsonWebToken().encode({"alg": "HS256"}, token, "")

# Decoding

# good -  "it will raise BadSignatureError when signature doesn’t match"
jwt.decode(token, key)
JsonWebToken().decode(token, key)
