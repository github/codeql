var Hapi = require('hapi');
var server = new Hapi.Server();
server.route({
    handler: function (request, reply){
        request.response.header('X-Frame-Options', 'DENY')
    }});
