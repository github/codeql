(function () {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser', // $ Alert
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba', // $ Alert
        port: 3211,
    });
    client.connect();
})();

(function () {
    const JwtStrategy = require('passport-jwt').Strategy;
    const passport = require('passport')

    var secretKey = "myHardCodedPrivateKey"; // OK - JWT keys in tests are not flagged

    const opts = {}
    opts.secretOrKey = secretKey;
    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        return done(null, false);
    }));

    passport.use(new JwtStrategy({
        secretOrKeyProvider: function (request, rawJwtToken, done) {
            return done(null, secretKey)
        }
    }, function (jwt_payload, done) {
        return done(null, false);
    }));
})();
