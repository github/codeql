(function() {
    script = sink;
    script + sink;
    run(sink);

    o.script = sink
    getScript() + sink
    script += sink;
    sink += script;
    o.run(sink);

    html = sink;
    html + sink;
    html(sink);

    sql = sink;
    sql + sink;
    query(sink);

    absolute = sink;
    absolute + sink;
    readFile(sink);

    regexp = sink;
    regexp + sink;
    match(sink);

    redirect = sink;
    redirect + sink;
    redirect(sink);

})();

app.get('/some/path', function(req, res) {
    var file = req.query.file;
    var FILE = req.query.file;
});

(function() {
    "function(){ var x = " + sink;
    sink + "= function(){";
    "x => " + sink;
    "foo[" + sink + "]";

    "<div>" + sink;
    '<div foo="foo"' + sink + 'bar="bar">';

    "SELECT " + sink;

    "/foo/bar" + sink;
    "foo/bar/" + sink;
    "foo/" + sink + "/bar";
})();

(function() {
    csrf = sink;
    csrf + sink;
})();

(function() {
    throw new Error('request url [' + req.url + '] does not start with [' + prefix + ']')
})();

(function() {
    errors.push("Got authorization of '" + req.headers.authorization + "' expected '" + auth + "'")
})();

app.get('/some/path', function(req, res) {
    var file = req.query.file || x;
    var file = x || req.query.file;
    var file = req.query.file || x || y;
    var file = x || req.query.file || y;
    var file = x || y || req.query.file;
});

app.get('/some/path', function(req, res) {
    var code = req.query.inviteCode;
})();
