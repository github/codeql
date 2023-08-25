require 'jwt'

token = JWT.encode({ foo: 'bar' }, nil, 'HS256')

decoded = JWT.decode(token, "secret", true, algorithm: 'HS256')
