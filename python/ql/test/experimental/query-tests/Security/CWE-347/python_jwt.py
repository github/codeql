import python_jwt

# GOOD

token1 = "1"
python_jwt.process_jwt(token1)
python_jwt.verify_jwt(token1, "key", "HS256")

# BAD

# no call to verify_jwt
token2 = "123"
python_jwt.process_jwt(token2)
