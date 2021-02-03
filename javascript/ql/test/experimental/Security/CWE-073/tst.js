var app = require('express')();
app.set('view engine', 'hbs');

app.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    var queryParameter = req.query.queryParameter;

    res.render('template', bodyParameter); // NOT OK
    res.render('template', queryParameter); // NOT OK

    if (typeof bodyParameter === "string") {
        res.render('template', bodyParameter); // OK - but still flagged [INCONSISTENCY]
    }
    res.render('template', queryParameter + ""); // OK - but still flagged [INCONSISTENCY]

    res.render('template', {profile: bodyParameter}); // OK
}); 