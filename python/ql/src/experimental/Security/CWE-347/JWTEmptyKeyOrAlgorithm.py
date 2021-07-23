import jwt

# algorithm set to None
jwt.encode(payload, "somekey", None)

# empty key
jwt.encode(payload, key="", algorithm="HS256")
