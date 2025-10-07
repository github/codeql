const express = require('express');
const app = express();

app.get('/test/json', function(req, res) {
    res.json(req.query.data);
});

app.get('/test/jsonp', function(req, res) {
    res.jsonp(req.query.data);
});
