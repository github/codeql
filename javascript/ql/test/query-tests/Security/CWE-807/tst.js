var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {

    process.exit();

    if(req.params.shutDown) { // $ Alert[js/user-controlled-bypass] - depends on user input
        process.exit();
    }

    if (req.cookies.loginThing) { // $ Alert[js/user-controlled-bypass] - depends on user input
        o.login();
    }

    if (req.cookies.loginThing) { // OK - not a sensitive action
        o.getLogin();
    }


    process.exit();

    function id(v) {
        return v;
    }
    var v3 = id(req.cookies.cookieId); // $ Source[js/user-controlled-bypass]
    if (v3) { // $ Alert[js/user-controlled-bypass] - depends on user input
        process.exit();
    }

    if (otherCondition) {
        if (req.cookies.cookieId) { // $ Alert[js/user-controlled-bypass] - depends on user input
            process.exit();
        }
    }

    if (req.cookies.cookieId) { // $ SPURIOUS: Alert[js/user-controlled-bypass] - flagged anyway due to plain dominance analysis
        if (otherCondition) {
            process.exit();
        }
    }

    if(req.params.login) { // $ Alert[js/user-controlled-bypass] - depends on user input

    } else {
        login()
    }


    if(req.params.login && somethingElse) { // OK - depends on something else

    } else {
        login()
    }

    if(req.params.login && somethingElse) { // $ Alert[js/user-controlled-bypass] - depends on user input
        login()
    }

    if (req.cookies.cookieId === req.params.requestId) { // $ Alert[js/different-kinds-comparison-bypass]
        process.exit();
    }

    var v1 = req.cookies.cookieId === req.params.requestId; // $ Alert[js/different-kinds-comparison-bypass]
    if (v1) {
        process.exit();
    }

    function cmp(p, q) {
        return p === q; // $ Alert[js/different-kinds-comparison-bypass]
    }
    var v2 = cmp(req.cookies.cookieId, req.params.requestId); // $ MISSING: Alert - not detected due to flow limitations
    if (v2) {
        process.exit();
    }

    if (req.cookies.cookieId === "secret") { // $ Alert[js/user-controlled-bypass] - depends on user input
        process.exit();
    }

    if (req.cookies.loginThing) {
        // OK - not a sensitive action
        unauthorized();
        // OK - not a sensitive action
        console.log(commit.author().toString());
    }
});

app.get('/user/:id', function(req, res) {
    if (!req.body || !username || !password || riskAssessnment == null) { // OK - early return below
        res.status(400).send({ error: '...', id: '...' });
        return
    }
    customerLogin.customerLogin(username, password, riskAssessment, clientIpAddress);

    while (!verified) {
        if (req.query.vulnerable) { // $ Alert[js/user-controlled-bypass]
            break;
        }
        verify();
    }

    while (!verified) {
        if (req.query.vulnerable) { // $ Alert[js/user-controlled-bypass]
            break;
        } else {
            verify();
        }
    }

    while (!verified) {
        if (req.query.vulnerable) { // OK - early return
            return;
        }
        verify();
    }

});
