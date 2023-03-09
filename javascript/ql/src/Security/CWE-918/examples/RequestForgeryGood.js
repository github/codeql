import http from 'http';

const server = http.createServer(function(req, res) {
    const target = new URL(req.url, "http://example.com").searchParams.get("target");

    let subdomain;
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
