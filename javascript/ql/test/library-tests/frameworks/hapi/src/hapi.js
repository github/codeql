var server1 = new (require('hapi')).Server(); // HTTP::Server

var Hapi = require('hapi');
var server2 = new Hapi.Server(); // HTTP::Server

function handler1(){} // HTTP::RouteHandler
server2.route({
    handler: handler1
});


server2.route({
    handler: function handler2(request, reply){ // HTTP::RouteHandler
        request.response.header('HEADER1', '') // HTTP::HeaderDefinition
    }});

server2.ext('onPreResponse', function handler3(request, reply) { // HTTP::RouteHandler
})

function handler4(request, reply){
  request.rawPayload;
  getRequest(request).payload.foo;
  getRequest(request).query.bar; getRequest(request).params.bar;
  request.url.path;
  request.headers.baz;
  request.state.token;
}
var route = {handler: handler4};
server2.route(route);

server2.cache({ segment: 'countries', expiresIn: 60*60*1000 });

function getHandler() {
    return function (req, h){}
}
server2.route({handler: getHandler()});

function getRequest(request) {
  return request;
}
