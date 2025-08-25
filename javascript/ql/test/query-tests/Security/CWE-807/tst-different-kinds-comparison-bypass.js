var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {

    req.query.userId == req.cookies.userId; // $ Alert[js/different-kinds-comparison-bypass]

    req.query.userId1 == req.query.userId2; // OK - same kind of source

    req.url == req.body; // $ Alert[js/different-kinds-comparison-bypass]

    check(req.query.userId, req.cookies.userId);

    function check(a, b) {
        a == b; // $ Alert[js/different-kinds-comparison-bypass]
    }

    // CSRF protection
    req.cookies.csrf == req.query.csrf;
    req.cookies.csrfToken == req.query.csrfToken;
    req.cookies.state == req.query.state;
    req.cookies.authState == req.query.authState;
    req.cookies.token == req.query.token;
});
