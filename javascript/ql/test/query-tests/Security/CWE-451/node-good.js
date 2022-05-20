var http = require('http')

http.createServer(function (request, response) {
    response.setHeader('X-Frame-Options', 'DENY');
  }).listen(9615)
