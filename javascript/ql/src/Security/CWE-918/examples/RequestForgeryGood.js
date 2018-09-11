import http from 'http';
import url from 'url';

var server = http.createServer(function(req, res) {
    var target = url.parse(request.url, true).query.target;

    var subdomain;
    if (target === 'EU') {
        subdomain = "europe"
    } else {
        subdomain = "world"
    }

    // GOOD: `subdomain` is controlled by the server
    http.get('https://' + subdomain + ".example.com/data/", res => {
        // process request response ...
    });

});
