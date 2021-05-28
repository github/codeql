var server1 = require('restify').createServer(); // https::Server

var restify = require('restify');
var server2 = restify.createServer(); // https::Server

function handler1(){} // https::RouteHandler
server2.get('/', handler1);

server2.head('/', function handler2(request, response){ // https::RouteHandler
    response.header('HEADER1', ''); // https::HeaderDefinition
});
server2.head('/', function handler3(request, response){ // https::RouteHandler
    response.setHeader('HEADER2', ''); // https::HeaderDefinition
    request.getQuery().foo;
    request.href();
    request.getPath();
    request.getContentType();
    request.userAgent();
    request.trailer('bar');
    request.header('baz');
    request.cookie;
});
