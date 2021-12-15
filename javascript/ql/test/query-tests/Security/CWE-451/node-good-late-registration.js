var http = require('http')

var server = http.createServer();

server.on("request", function (request, response) {
    response.setHeader('X-Frame-Options', 'DENY');
});

server.listen(9615)
