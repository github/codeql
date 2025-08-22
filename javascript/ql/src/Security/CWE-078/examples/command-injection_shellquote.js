var cp = require("child_process"),
    http = require('http'),
    url = require('url'),
    shellQuote = require('shell-quote');

var server = http.createServer(function(req, res) {
    let options = url.parse(req.url, true).query.options;

    cp.execFileSync('wc', shellQuote.parse(options)); // GOOD
});
