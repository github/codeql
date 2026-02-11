var express = require('express');
var cookieParser = require('cookie-parser');
var passport = require('passport');

var app = express();

app.use(cookieParser()); // $ Alert
app.use(passport.authorize({ session: true }));

app.post('/changeEmail', function (req, res) {
    let newEmail = req.cookies["newEmail"];
}); // $ RelatedLocation

(function () {
    var app = express();

    app.use(cookieParser()); // $ Alert
    app.use(passport.authorize({ session: true }));

    const errorCatch = (fn) =>
        (req, res, next) => {
            fn(req, res, next).catch((e) => console.log("Caught " + e));
        };

    app.post('/changeEmail', errorCatch(async function (req, res) {
        let newEmail = req.cookies["newEmail"];
    })); // $ RelatedLocation
})

(function () {
    var app = express();

    app.use(cookieParser()); // $ Alert
    app.use(passport.authorize({ session: true }));

    const errorCatch = (fn) =>
        (req, res, next) => {
            fn.call(this, req, res, next).catch((e) => console.log("Caught " + e));
        };

    app.post('/changeEmail', errorCatch(async function (req, res) {
        let newEmail = req.cookies["newEmail"];
    })); // $ RelatedLocation

    app.post('/doLoginStuff', errorCatch(async function (req, res) {
        req.session.user = loginStuff(req);
    })); // $ RelatedLocation
})
