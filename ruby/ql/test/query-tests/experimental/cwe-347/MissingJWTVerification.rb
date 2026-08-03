require 'jwt'

payload = { foo: 'bar' }

# Unsecure token
token_without_signature = JWT.encode(payload, nil, 'none') # $ Alert[rb/jwt-empty-secret-or-algorithm]

# Secure token
token = JWT.encode(payload, "secret", 'HS256')

# BAD: it does not verify
decoded_token1 = JWT.decode(token_without_signature, nil, false, algorithm: 'HS256') # $ Alert[rb/jwt-missing-verification]

# BAD: it's using none
decoded_token3 = JWT.decode(token_without_signature, secret, true, algorithm: 'none') # $ Alert[rb/jwt-missing-verification]

# BAD: it's using none
decoded_token4 = JWT.decode(token_without_signature, secret, true, { algorithm: 'none' }) # $ Alert[rb/jwt-missing-verification]

# GOOD: it does verify
decoded_token5 = JWT.decode(token, secret, 'HS256')

# GOOD: it does verify
decoded_token2 = JWT.decode(token,secret)
