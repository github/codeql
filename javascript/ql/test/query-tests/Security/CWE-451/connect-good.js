var connect = require('connect');
var http = require('http');

var app = connect();

app.use(function (req, res){
    res.setHeader('X-Frame-Options', 'DENY');
});
