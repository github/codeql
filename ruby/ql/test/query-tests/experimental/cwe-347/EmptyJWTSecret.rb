require 'jwt'

payload = { foo: 'bar' }

# BAD: the token is not signed
token1 = JWT.encode({ foo: 'bar' }, "secret", 'none')

# BAD: the secret used is empty
token2 = JWT.encode({ foo: 'bar' }, nil, 'HS256')

# BAD: the secret used is empty
token3 = JWT.encode({ foo: 'bar' }, "", 'HS256')

# GOOD: the token is signed
token4 = JWT.encode({ foo: 'bar' }, "secret", 'HS256')