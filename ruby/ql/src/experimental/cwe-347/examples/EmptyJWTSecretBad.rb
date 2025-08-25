require 'jwt'

token1 = JWT.encode({ foo: 'bar' }, "secret", 'none')

token2 = JWT.encode({ foo: 'bar' }, nil, 'HS256')