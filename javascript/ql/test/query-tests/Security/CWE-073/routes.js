exports.foo = function(req, res) {
    res.render('foo', req.body); // NOT OK
}
