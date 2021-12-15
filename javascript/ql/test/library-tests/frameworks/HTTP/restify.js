var restify = require('restify');

function respond(req, res, next) {
    req.getQuery().p1;
    req.href();
    req.getPath();
    req.getContentType();
    req.userAgent();
    req.trailer();
    req.header();
    req.url;
    req.cookies;
}

var server = restify.createServer();
server.get('/hello/:name', respond);
