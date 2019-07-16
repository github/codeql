var escape = require('escape-html');
var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id))
    // GOOD: request parameter is sanitized before incorporating it into the response
    res.send("Unknown user: " + escape(req.params.id));
  else
    // TODO: do something exciting
    ;
});


app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id))
    // GOOD: templating prevents XSS
    res.render(invalidUserIdTemplate, { id: req.params.id });
});

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id)) {
    // GOOD: response content type set to text
    res.set('Content-Type', 'text/plain');
    res.send("Unknown user: " + req.params.id);
  } else
    // TODO: do something exciting
    ;
});

function textContentType() {
  result = "text/plain";
}

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id)) {
    // GOOD: response content type set to text
    res.set('Content-Type', textContentType());
    res.send("Unknown user: " + req.params.id);
  } else
    // TODO: do something exciting
    ;
});

app.get('/echo', function(req, res) {
	var msg = req.params.msg;
	res.setHeader('Content-Type', 'application/json');
	res.setHeader('Content-Length', msg.length);
	res.end(msg);
});
