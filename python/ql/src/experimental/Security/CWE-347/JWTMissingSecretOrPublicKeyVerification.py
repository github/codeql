import jwt

# unverified decoding
jwt.decode(payload, key="somekey", verify=False)
