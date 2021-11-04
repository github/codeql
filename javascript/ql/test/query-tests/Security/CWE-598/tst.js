const express = require('express');
const app = express();
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: true}));

app.get("/login", (req, res) => {
    const username = req.query.username; // OK - usernames are fine
    const password = req.query.password; // NOT OK - password read
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