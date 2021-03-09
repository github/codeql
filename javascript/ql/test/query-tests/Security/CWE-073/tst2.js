const handlebars = require("express-handlebars");
var app = require('express')();
app.engine( '.hbs', handlebars({ defaultLayout: 'main', extname: '.hbs' }) ); 
app.set('view engine', '.hbs')
app.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter); // NOT OK
}); 

var app2 = require('express')();
app2.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter); // OK
}); 

var app3 = require('express')();
app3.set('view engine', 'pug');
app3.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter); // OK
}); 

var app4 = require('express')();
app4.set('view engine', 'ejs');
app4.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter); // NOT OK
}); 

var app5 = require('express')();
app5.engine("foobar", require("consolidate").whiskers);
app5.set('view engine', 'foobar');
app5.post('/path', function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter); // NOT OK
}); 
