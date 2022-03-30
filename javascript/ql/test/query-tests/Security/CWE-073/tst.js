var app = require('express')();
app.set('view engine', 'hbs');

app.use(require('body-parser').json());
app.use(require('body-parser').urlencoded({ extended: false }));
app.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    var queryParameter = req.query.queryParameter;

    res.render('template', bodyParameter); // NOT OK
    res.render('template', queryParameter); // NOT OK

    if (typeof bodyParameter === "string") {
        res.render('template', bodyParameter); // OK
    }
    res.render('template', queryParameter + ""); // OK

    res.render('template', {profile: bodyParameter}); // OK

    indirect(res, queryParameter);
}); 

function indirect(res, obj) {
    res.render("template", obj); // NOT OK

    const str = obj + "";
    res.render("template", str); // OK 

    res.render("template", JSON.parse(str)); // NOT OK
}

let routes = require('./routes');
app.post('/foo', routes.foo);
