import http from 'http';
import url from 'url';

var server = http.createServer(function(req, res) {
    var target = url.parse(req.url, true).query.target;

    // BAD: `target` is controlled by the attacker
    http.get('https://' + target + ".example.com/data/", res => {
        // process request response ...
    });

});
