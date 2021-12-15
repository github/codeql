var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {

    req.query.userId == req.cookies.userId; // NOT OK

    req.query.userId1 == req.query.userId2; // OK, same kind of source

    req.url == req.body; // NOT OK

    check(req.query.userId, req.cookies.userId);

    function check(a, b) {
        a == b; // NOT OK
    }

    // CSRF protection
    req.cookies.csrf == req.query.csrf; // OK
    req.cookies.csrfToken == req.query.csrfToken; // OK
    req.cookies.state == req.query.state; // OK
    req.cookies.authState == req.query.authState; // OK
    req.cookies.token == req.query.token; // OK
});
