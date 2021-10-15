var https = require('https'),
    url = require('url');

var server = https.createServer(function(){});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin,
        whitelist = {
            "https://example.com": true,
            "https://subdomain.example.com": true,
            "https://example.com:1337": true
        };

    if (origin in whitelist) {
        // GOOD: the origin is in the whitelist
        res.setHeader("Access-Control-Allow-Origin", origin);
        res.setHeader("Access-Control-Allow-Credentials", true);
    }

    // ...
});
