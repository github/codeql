var Hapi = require('hapi');
var server = new Hapi.Server();
server.route({
    handler: function (request, reply){
        request.rawPayload;
        request.payload.p1;
        request.query.p2;
        request.url.path;
        request.headers.p3;
        request.state.p4;
    }});
