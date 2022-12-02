import http from 'http';

const server = http.createServer(function(req, res) {
    const target = new URL(req.url).searchParams.get("target");

    // BAD: `target` is controlled by the attacker
    http.get('https://' + target + ".example.com/data/", res => {
        // process request response ...
    });

});
