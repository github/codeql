(function () {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba',
        port: 3211,
    });
    client.connect();
})();

(function () {
    const JwtStrategy = require('passport-jwt').Strategy;
    const passport = require('passport')

    var secretKey = "myHardCodedPrivateKey";

    const opts = {}
    opts.secretOrKey = secretKey; // $ Alert
    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        return done(null, false);
    }));

    passport.use(new JwtStrategy({
        secretOrKeyProvider: function (request, rawJwtToken, done) {
            return done(null, secretKey) // $ Alert
        }
    }, function (jwt_payload, done) {
        return done(null, false);
    }));
})();
