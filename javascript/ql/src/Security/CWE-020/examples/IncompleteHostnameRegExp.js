app.get('/some/path', function(req, res) {
    let url = req.param('url'),
        host = urlLib.parse(url).host;
    // BAD: the host of `url` may be controlled by an attacker
    let regex = /^((www|beta).)?example.com/;
    if (host.match(regex)) {
        res.redirect(url);
    }
});
