const express = require('express');
const session = require('express-session');
var bodyParser = require('body-parser')
const app = express();
app.use(bodyParser.urlencoded({ extended: false }))
app.use(session({
    secret: 'keyboard cat'
}));

app.post('/login', function (req, res) {
    // Check that username password matches
    if (req.body.username === 'admin' && req.body.password === 'admin') {
        req.session.authenticated = true;
        res.redirect('/');
    } else {
        res.redirect('/login');
    }
});