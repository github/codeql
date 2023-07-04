var cp = require("child_process"),
    http = require('http'),
    path = require('path'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let file = path.basename(url.parse(req.url, true).query.path);

    cp.execFileSync('wc', ['-l', file]); // GOOD
});
