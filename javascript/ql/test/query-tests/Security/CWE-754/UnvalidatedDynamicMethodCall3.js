var express = require('express');
var app = express();

var actions = new Map();
actions.set("play", function play(data) {
    // ...
});
actions.set("pause", function pause(data) {
    // ...
});

app.get('/perform/:action/:payload', function(req, res) {
    if (actions.has(req.params.action)) {
        let action = actions.get(req.params.action);
        res.end(action(req.params.payload)); // NOT OK, but not flagged [INCONSISTENCY]
    }
});
