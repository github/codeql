require 'jwt'

token = JWT.encode({ foo: 'bar' }, "secret", 'HS256')