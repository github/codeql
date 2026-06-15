var cp = require("child_process"),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let file = url.parse(req.url, true).query.path;

    // only allow safe characters in file name
    if (file.match(/^[\w\.\-\/]+$/)) {
        cp.execSync(`wc -l ${file}`); // GOOD
    }
});
