// jsonwebtoken
const jwtJsonwebtoken = require('jsonwebtoken');
const {getSecret} = require('./Config.js');
const payloads = {foo: 'bar'}
const token = jwtJsonwebtoken.sign(payloads, getSecret());
// BAD: no verification
jwtJsonwebtoken.decode(token)
// jwt-decode
// BAD: no verification
const jwt_decode = require('jwt-decode');
jwt_decode(token)
// jose
const jose = require('jose')
// BAD: no verification
jose.decodeJwt(token)
// jwt-simple
const jwt_simple = require('jwt-simple');
// no verification
jwt_simple.decode(token, getSecret(), false);
