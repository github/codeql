var express = require('express');
var app = express();
app.get('/some/path', function() {
    f(req.query.password); // $ Source[js/clear-text-logging]
})

function f(x) {
    console.log(x); // $ Alert[js/clear-text-logging]
}
