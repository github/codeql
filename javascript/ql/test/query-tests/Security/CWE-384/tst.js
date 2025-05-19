const express = require('express');
const session = require('express-session');
const passport = require('passport');
const app = express();
app.use(session({
    secret: 'keyboard cat'
}));
// handle login
app.get('/login', function (req, res) { // no regenerate
    req.session.user = {
        userId: something
    };
    res.send('logged in');
}); // $ Alert

// with regenerate
app.get('/login2', function (req, res) {
    req.session.regenerate(function (err) {
        req.session.user = {
            userId: something
        };
        res.send('logged in');
    });
});

// using passport
app.get('/passport', passport.authenticate('local'), function (req, res) { // OK - passport is safe
    res.send('logged in');
});

// with regenerate, still using passport
app.get('/passport2', passport.authenticate('local'), function (req, res) {
    var passport = req._passport.instance;
    req.session.regenerate(function(err, done, user) {
        req.session[passport._key] = {};
        req._passport.instance = passport;
        req._passport.session = req.session[passport._key];
        res.send('logged in');
    });
});
