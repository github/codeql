var express = require('express');
var app = express();
app.get('/some/path', function() {
    f(req.query.password);
})

function f(x) {
    console.log(x);
}
