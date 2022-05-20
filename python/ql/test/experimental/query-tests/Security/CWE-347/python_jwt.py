import python_jwt

# GOOD


def good(token):
    python_jwt.process_jwt(token)
    python_jwt.verify_jwt(token, "key", "HS256")

# BAD


def bad(token):
    python_jwt.process_jwt(token)
