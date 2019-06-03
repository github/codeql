app.get("/some/path", function(req, res) {
    let url = req.param("url");
    // GOOD: the host of `url` can not be controlled by an attacker
    if (url.match(/^https?:\/\/www\.example\.com\//)) {
        res.redirect(url);
    }
});
