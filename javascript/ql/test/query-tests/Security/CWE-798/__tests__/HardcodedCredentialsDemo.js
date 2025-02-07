(function () {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser', // $ TODO-SPURIOUS: Alert
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba', // $ TODO-SPURIOUS: Alert
        port: 3211,
    });
    client.connect();
})();

(function () {
    const JwtStrategy = require('passport-jwt').Strategy;
    const passport = require('passport')

    var secretKey = "myHardCodedPrivateKey";

    const opts = {}
    opts.secretOrKey = secretKey; // $ TODO-MISSING: Alert
    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        return done(null, false);
    }));

    passport.use(new JwtStrategy({
        secretOrKeyProvider: function (request, rawJwtToken, done) {
            return done(null, secretKey) // $ TODO-MISSING: Alert
        }
    }, function (jwt_payload, done) {
        return done(null, false);
    }));
})();
