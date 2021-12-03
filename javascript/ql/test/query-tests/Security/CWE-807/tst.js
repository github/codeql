var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
     // OK
    process.exit();

    if(req.params.shutDown) { // NOT OK: depends on user input
        process.exit();
    }

    if (req.cookies.loginThing) { // NOT OK: depends on user input
        o.login();
    }

    if (req.cookies.loginThing) { // OK: not a sensitive action
        o.getLogin();
    }

    // OK
    process.exit();

    function id(v) {
        return v;
    }
    var v3 = id(req.cookies.cookieId);
    if (v3) { // NOT OK, depends on user input
        process.exit();
    }

    if (otherCondition) {
        if (req.cookies.cookieId) { // NOT OK: depends on user input
            process.exit();
        }
    }

    if (req.cookies.cookieId) { // OK: but flagged anyway due to plain dominance analysis [INCONSISTENCY]
        if (otherCondition) {
            process.exit();
        }
    }

    if(req.params.login) { // NOT OK: depends on user input

    } else {
        login()
    }


    if(req.params.login && somethingElse) { // OK: depends on something else

    } else {
        login()
    }

    if(req.params.login && somethingElse) { // NOT OK: depends on user input
        login()
    }

    if (req.cookies.cookieId === req.params.requestId) { // NOT OK: depends on user input
        process.exit();
    }

    var v1 = req.cookies.cookieId === req.params.requestId; // NOT OK: depends on user input
    if (v1) {
        process.exit();
    }

    function cmp(p, q) {
        return p === q;
    }
    var v2 = cmp(req.cookies.cookieId, req.params.requestId); // NOT OK, but not detected due to flow limitations [INCONSISTENCY]
    if (v2) {
        process.exit();
    }

    if (req.cookies.cookieId === "secret") { // NOT OK: depends on user input
        process.exit();
    }

    if (req.cookies.loginThing) {
        // OK: not a sensitive action
        unauthorized();
        // OK: not a sensitive action
        console.log(commit.author().toString());
    }
});

app.get('/user/:id', function(req, res) {
    if (!req.body || !username || !password || riskAssessnment == null) { // OK: early return below
        res.status(400).send({ error: '...', id: '...' });
        return
    }
    customerLogin.customerLogin(username, password, riskAssessment, clientIpAddress);

    while (!verified) {
        if (req.query.vulnerable) { // NOT OK
            break;
        }
        verify();
    }

    while (!verified) {
        if (req.query.vulnerable) { // NOT OK
            break;
        } else {
            verify();
        }
    }

    while (!verified) {
        if (req.query.vulnerable) { // OK: early return
            return;
        }
        verify();
    }

});
