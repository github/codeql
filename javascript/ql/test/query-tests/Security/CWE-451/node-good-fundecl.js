var http = require('http')

function headers (request, response) {
    response.setHeader('X-Frame-Options', 'DENY');
  }
http.createServer(headers).listen(9615)
