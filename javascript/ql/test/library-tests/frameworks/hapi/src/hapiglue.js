var server1 = new (require('@hapi/glue')).compose(require("./manifest"), composeOptions); // test_ServerDefinition

var Hapi = require('@hapi/glue');
var server2 = new Hapi.compose(require("./manifest"), composeOptions); // test_ServerDefinition

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
  request.payload.foo;
  request.query.bar;
  request.params.bar;
  request.url.path;
  request.url.origin;
  request.headers.baz;
  request.state.token;
}
var route = {handler: handler4};
server2.route(route);

server2.cache({ segment: 'countries', expiresIn: 60*60*1000 });

function getHandler() {
    return function (req, hapi){}
}
server2.route({handler: getHandler()});

function after(server) {
};

function register(server, options) {// test_ServerDefinition
    server.dependency(options.dependencies, server_ => after(server_, options)); // test_ServerDefinition
}

module.exports.plugin = {
    register,
    pkg
};
