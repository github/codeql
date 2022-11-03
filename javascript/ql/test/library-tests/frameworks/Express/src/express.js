var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {
  res.redirect(req.param("target"));
  res.header("Location", req.param("target"));
  res.header("Content-Type", "text/plain");
  foo(res);
});

function foo(arg) {
  arg.header("Access-Control-Allow-Credentials", true);
}

function installRoute(router) {
  router.get('/', function(req, res) {
    res.send("Go away.");
  });
}
installRoute(app);

app.post('/some/other/path', function(req, res) {
  req.body;
  req.params.foo;
  req.query.bar;
  req.url;
  req.originalUrl;
  req.get("foo");
  req.header("bar");
  req.cookies;
  res.cookie('foo', 'bar');
});

app.get('/', require('./exportedHandler.js').handler);

function getHandler() {
    return function (req, res){}
}
app.use(getHandler());

function getArrowHandler() {
    return (req, res) => f();
}
app.use(getArrowHandler());

app.post('/headers', function(req, res) {
  req.headers.baz;
  req.host;
  req.hostname;
  req.headers[config.headerName];
});
