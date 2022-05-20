var http = require('http')
function f(response){
    response.setHeader('X-Frame-Options', 'DENY');
}
http.createServer(function (request, response) {
    f(response);
}).listen(9615);
