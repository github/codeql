const handlebars = require("express-handlebars");
var app = require('express')();
app.engine( '.hbs', handlebars({ defaultLayout: 'main', extname: '.hbs' }) ); 
app.set('view engine', '.hbs')
app.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    res.render('template', bodyParameter); // $ Alert
}); 

var app2 = require('express')();
app2.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter);
}); 

var app3 = require('express')();
app3.set('view engine', 'pug');
app3.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter;
    res.render('template', bodyParameter);
}); 

var app4 = require('express')();
app4.set('view engine', 'ejs');
app4.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    res.render('template', bodyParameter); // $ Alert
}); 

var app5 = require('express')();
app5.engine("foobar", require("consolidate").whiskers);
app5.set('view engine', 'foobar');
app5.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    res.render('template', bodyParameter); // $ Alert
}); 

var app6 = require('express')();
app6.register(".html", require("consolidate").whiskers);
app6.set('view engine', 'html');
app6.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    res.render('template', bodyParameter); // $ Alert
}); 

const express = require('express');
var router = express.Router();
var app7 = express();
app7.set('view engine', 'ejs');
router.post('/path', require('body-parser').json(), function(req, res) {
    var bodyParameter = req.body.bodyParameter; // $ Source
    res.render('template', bodyParameter); // $ Alert
});
app7.use("/router", router);