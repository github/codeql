const express = require('express');
const app = express();
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: true}));

app.get("/login", (req, res) => {
    const username = req.query.username; // OK - usernames are fine
    const password = req.query.password; // $ Alert - password read
    checkUser(username, password, (result) => {
        res.send(result);
    });

    doThing(req.query.userId); // OK - userId
});

app.post("/login", (req, res) => {
    const username = req.body.username; // OK - usernames are fine
    const password = req.body.password; // OK - not a query parameter
    checkUser(username, password, (result) => {
        res.send(result);
    });
});

app.get("/login2", (req, res) => {
    const username = req.param('username'); // OK - usernames are fine
    const password = req.param('password'); // $ Alert - password read
    checkUser(username, password, (result) => {
        res.send(result);
    });

    const myPassword = req.param('word'); // $ Alert - is used in a sensitive write below.
    checkUser(username, myPassword, (result) => {
        res.send(result);
    });
});

app.get("/login", ({query}, res) => {
    const username = query.username; // OK - usernames are fine
    const currentPassword = query.current; // $ Alert - password read
    checkUser(username, currentPassword, (result) => {
        res.send(result);
    });
});

app.get('/rest/user/change-password', mkHandler());

function mkHandler() {
    return (req, res) => {
        const username = req.param('username'); // OK - usernames are fine
        const currentPassword = req.param('current'); // $ Alert - password read
        checkUser(username, currentPassword, (result) => {
            res.send(result);
        });
    }
}
