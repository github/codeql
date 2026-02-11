var app = require('express')();
app.set('view engine', 'hbs');

app.use(require('body-parser').json());
app.use(require('body-parser').urlencoded({ extended: false }));
app.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    var queryParameter = req.query.queryParameter; // $ Source

    res.render('template', bodyParameter); // $ Alert
    res.render('template', queryParameter); // $ Alert

    if (typeof bodyParameter === "string") {
        res.render('template', bodyParameter);
    }
    res.render('template', queryParameter + "");

    res.render('template', {profile: bodyParameter});

    indirect(res, queryParameter);
}); 

function indirect(res, obj) {
    res.render("template", obj); // $ Alert

    const str = obj + "";
    res.render("template", str);

    res.render("template", JSON.parse(str)); // $ Alert
}

let routes = require('./routes');
app.post('/foo', routes.foo);
