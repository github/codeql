var server1 = require('restify').createServer(); // HTTP::Server

var restify = require('restify');
var server2 = restify.createServer(); // HTTP::Server

function handler1(){} // HTTP::RouteHandler
server2.get('/', handler1);

server2.head('/', function handler2(request, response){ // HTTP::RouteHandler
    response.header('HEADER1', ''); // HTTP::HeaderDefinition
});
server2.head('/', function handler3(request, response){ // HTTP::RouteHandler
    response.setHeader('HEADER2', ''); // HTTP::HeaderDefinition
    request.getQuery().foo;
    request.href();
    request.getPath();
    request.getContentType();
    request.userAgent();
    request.trailer('bar');
    request.header('baz');
    request.cookie;
});
