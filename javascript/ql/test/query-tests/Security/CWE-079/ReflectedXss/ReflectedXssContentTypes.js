var express = require('express');
var app = express();

app.get('/user/:id', function (req, res) {
  if (whatever) {
    res.set('Content-Type', 'text/plain');
    res.send("FOO: " + req.params.id); // OK - content type is plain text
  } else {
    res.set('Content-Type', 'text/html');
    res.send("FOO: " + req.params.id); // NOT OK - content type is HTML.
  }
});

app.get('/user/:id', function (req, res) {
  if (whatever) {
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.send("FOO: " + req.params.id); // OK - content type is JSON
  } else {
    res.writeHead(404);
    res.send("FOO: " + req.params.id); // NOT OK - content type is not set.
  }
});


app.get('/user/:id', function (req, res) {
  res.writeHead(200, {'Content-Type': 'application/json'});
  if (whatever) {
    res.send("FOO: " + req.params.id); // OK - content type is JSON
  } else {
    res.send("FOO: " + req.params.id); // OK - content type is still JSON
  }
  res.send("FOO: " + req.params.id); // OK - content type is still JSON
});


app.get('/user/:id', function (req, res) {
  if (err) {
    res.statusCode = 404;
    res.end("FOO: " + req.params.id); // NOT OK
  } else {
    res.setHeader('Content-Type', 'text/plain;charset=utf8');
    res.end("FOO: " + req.params.id); // OK
  }
});

function textContentType() {
  result = "text/plain";
}

app.get('/user/:id', function (req, res) {
  if (err) {
    res.header({'Content-Type': textContentType()});
    res.end("FOO: " + req.params.id); // OK
  } else {
    res.setHeader('Content-Type', 'text/plain;charset=utf8');
    res.end("FOO: " + req.params.id); // OK
  }
});

app.get('/user/:id', function (req, res) {
  if (err) {
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.send("FOO: " + req.params.id); // OK - content type is JSON
    return;
  }
  doSomething();
  somethingMore();
  while(Math.random()) {};
  res.writeHead(404);
  res.send("FOO: " + req.params.id); // NOT OK - content type is not set.
});

app.get('/user/:id', function (req, res) {
  res.header({'Content-Type': textContentType()});
  myFancyFunction(() => {
	res.send("FOO: " + req.params.id); // OK
  });
  res.end("FOO: " + req.params.id); // OK
});