require 'jwt'

token = JWT.encode({ foo: 'bar' }, nil, 'none')

decoded1 = JWT.decode(token, nil, false, algorithm: 'HS256')

decoded2 = JWT.decode(token, "secret", true, algorithm: 'none')