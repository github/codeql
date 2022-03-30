var https = require('https');
var url = require('url');

var server = https.createServer(function(){});

server.on('request', function(req, res) {
    res.setHeader("Access-Control-Allow-Origin", "https://semmle.com"); // OK, fixed origin
    res.setHeader("Access-Control-Allow-Credentials", true);
});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin;
    res.setHeader("Access-Control-Allow-Origin", origin); // NOT OK, tainted origin
    res.setHeader("Access-Control-Allow-Credentials", true);
});

server.on('request', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", null); // NOT OK, null origin
    res.setHeader("Access-Control-Allow-Credentials", true);
});

server.on('request', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "null"); // NOT OK, null origin
    res.setHeader("Access-Control-Allow-Credentials", true);
});

server.on('request', function(req, res) {
    let origin = url.parse(req.url, true).query.origin;
    res.setHeader("Access-Control-Allow-Origin", origin);  // OK, credentials are not transferred
});

server.on('request', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", null); // OK, credentials are not transferred
});

server.on('request', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", null); // OK, credentials are not transferred
    res.setHeader("Access-Control-Allow-Credentials", false);
});

server.on('request', (req, res) => {
    let origin = url.parse(req.url, true).query.origin;
    if (origin in o) {
        res.setHeader("Access-Control-Allow-Origin", origin); // OK, sanitized origin
        res.setHeader("Access-Control-Allow-Credentials", true);
    }
});

// syntactic header defintion
probalyAServer.on('request', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", null); // NOT OK (but not detected) [INCONSISTENCY]
    res.setHeader("Access-Control-Allow-Credentials", true);
});

server.on('request', (req, res) => {
    let origin = url.parse(req.url, true).query.origin;
    if (ALLOWED_ORIGINS.indexOf(origin) !== -1) {
        res.setHeader("Access-Control-Allow-Origin", origin); // OK, sanitized origin
        res.setHeader("Access-Control-Allow-Credentials", true);
    }
});

server.on('request', (req, res) => {
    let origin = url.parse(req.url, true).query.origin;
    if (ALLOWED_ORIGINS.indexOf(origin) >= 0) {
        res.setHeader("Access-Control-Allow-Origin", origin); // OK, sanitized origin
        res.setHeader("Access-Control-Allow-Credentials", true);
    }
});
