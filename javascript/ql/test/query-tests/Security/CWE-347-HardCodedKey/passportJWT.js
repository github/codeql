var JwtStrategy = require('passport-jwt').Strategy,
    ExtractJwt = require('passport-jwt').ExtractJwt;
var {getSecret} = require('./Config.js');
var opts = {}
opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken();
opts.secretOrKey = getSecret();
opts.issuer = 'accounts.examplesoft.com';
opts.audience = 'yoursite.net';
const newPassportUse = new JwtStrategy(opts, function (jwt_payload, done) {

    return done(null, false);

})
