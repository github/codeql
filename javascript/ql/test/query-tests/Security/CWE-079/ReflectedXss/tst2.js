var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  let { p, q: r } = req.params;
  res.send(p); // NOT OK
  res.send(r); // NOT OK
});

const aKnownValue = "foo";

app.get('/bar', function(req, res) {
  let { p } = req.params;

  if (p == aKnownValue)
    res.send(p); // OK
  res.send(p);   // NOT OK

  if (p != aKnownValue)
    res.send(p); // NOT OK
  else
    res.send(p); // OK
});


const clone = require('clone');

app.get('/baz', function(req, res) {
  let { p } = req.params;

  var obj = {};
  obj.p = p;
  var other = clone(obj);

  res.send(p); // NOT OK
  res.send(other.p); // NOT OK
});

const serializeJavaScript = require('serialize-javascript');

app.get('/baz', function(req, res) {
  let { p } = req.params;

  var serialized = serializeJavaScript(p);

  res.send(serialized); // OK
  
  var unsafe = serializeJavaScript(p, {unsafe: true});

  res.send(unsafe); // NOT OK
});

const fclone = require('fclone');

app.get('/baz', function(req, res) {
  let { p } = req.params;

  var obj = {};
  obj.p = p;
  var other = fclone(obj);

  res.send(p); // NOT OK
  res.send(other.p); // NOT OK
});

const jc = require('json-cycle');
app.get('/baz', function(req, res) {
  let { p } = req.params;

  var obj = {};
  obj.p = p;
  var other = jc.retrocycle(jc.decycle(obj));

  res.send(p); // NOT OK
  res.send(other.p); // NOT OK
});

const sortKeys = require('sort-keys');

app.get('/baz', function(req, res) {
  let { p } = req.params;

  var obj = {};
  obj.p = p;
  var other = sortKeys(obj);

  res.send(p); // NOT OK
  res.send(other.p); // NOT OK
});