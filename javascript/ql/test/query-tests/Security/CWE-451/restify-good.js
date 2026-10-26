var restify = require('restify');
var server = restify.createServer();
server.head('/', function (request, response){
    response.header('X-Frame-Options', 'DENY')
});
