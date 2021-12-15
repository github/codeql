var https = require('https'),
    url = require('url');

var server = https.createServer(function(){});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin;
     // BAD: attacker can choose the value of origin
    res.setHeader("Access-Control-Allow-Origin", origin);
    res.setHeader("Access-Control-Allow-Credentials", true);

    // ...
});
