var connect = require('connect');
var http = require('http');

var app = connect(); // https::Server

app.use(function handler1(req, res){ // https:RouteHandler
    res.setHeader('HEADER1', ''); // https:HeaderDefinition
    req.cookies.get('foo');
});

var basicAuth = require('basic-auth-connect');
app.use(basicAuth('username', 'password'));

function getHandler() {
    return function (req, res){}
}
app.use(getHandler());

app.use(function(req,res){})
    .use(function(req,res){})
    .notUse(function(req,res){})
    .use(function(req,res){});

app.use(function (error, req, res, next){
    res.setHeader('HEADER2', '');
});

app.use(function ({url, query, cookies}, res){
    cookies.get(query.foobar);
});
