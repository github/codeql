var express = require('express');
var cookieParser = require('cookie-parser');
var passport = require('passport');

(function () {

    var app = express()

    app.use(cookieParser())
    app.use(passport.authorize({ session: true }))

    function getCsrfToken(request) {
        return request.headers['x-xsrf-token'];
    }

    function setCsrfToken(request, response, next) {
        response.cookie('XSRF-TOKEN', request.csrfToken());
        next();
    }

    const csrf = {
        getCsrfToken: getCsrfToken,
        setCsrfToken: setCsrfToken
    };

    app.use(express.csrf({ value: csrf.getCsrfToken }));
    app.use(csrf.setCsrfToken);

    app.post('/changeEmail', function (req, res) {
        let newEmail = req.cookies["newEmail"];
    })
});



(function () {
    var app = express()

    app.use(cookieParser())
    app.use(passport.authorize({ session: true }))

    var crypto = require('crypto');

    var generateToken = function (len) {
        return crypto.randomBytes(Math.ceil(len * 3 / 4))
            .toString('base64')
            .slice(0, len);
    };
    function defaultValue(req) {
        return (req.body && req.body._csrf)
            || (req.query && req.query._csrf)
            || (req.headers['x-csrf-token']);
    }
    var checkToken = function (req, res, next) {
        var token = req.session._csrf || (req.session._csrf = generateToken(24));
        if ('GET' == req.method || 'HEAD' == req.method || 'OPTIONS' == req.method) return next();
        var val = defaultValue(req);
        if (val != token) return next(function () {
            res.send({ auth: false });
        });
        next();
    }
    const csrf = {
        check: checkToken
    };

    app.use(express.cookieParser());
    app.use(express.session({ secret: 'thomasdavislovessalmon' }));
    app.use(express.bodyParser());
    app.use(csrf.check);

    app.post('/changeEmail', function (req, res) {
        let newEmail = req.cookies["newEmail"];
    })
});

(function () {

    var app = express()

    app.use(cookieParser())
    app.use(passport.authorize({ session: true }))

    // Assume token is being set somewhere
    app.use(express.csrf({ value: function (request) {
        return request.headers['x-xsrf-token'];
    }}));

    app.post('/changeEmail', function (req, res) {
        let newEmail = req.cookies["newEmail"];
    })
});


(function () {
    var app = express()

    app.use(cookieParser())
    app.use(passport.authorize({ session: true }))

    function checkToken(req, res, next) {
        if (req.headers.xsrfToken !== req.session.xsrfToken) {
            throw new Error("Halt and catch fire!")
        }
        next();
    }

    function setCsrfToken(req, response, next) {
        req.session.xsrfToken = req.csrfToken();
        next();
    }

    app.use(checkToken);

    app.post('/changeEmail', function (req, res) {
        let newEmail = req.cookies["newEmail"];
    });

    app.use(setCsrfToken); // There is nothing wrong with setting the token late, as long as it is checked early.
});
