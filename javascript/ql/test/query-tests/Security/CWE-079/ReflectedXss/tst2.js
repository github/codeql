var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  let { p, q: r } = req.params; // $ Source
  res.send(p); // $ Alert
  res.send(r); // $ Alert
});

const aKnownValue = "foo";

app.get('/bar', function(req, res) {
  let { p } = req.params; // $ Source

  if (p == aKnownValue)
    res.send(p);
  res.send(p);   // $ Alert

  if (p != aKnownValue)
    res.send(p); // $ Alert
  else
    res.send(p);
});


const clone = require('clone');

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ Source

  var obj = {};
  obj.p = p;
  var other = clone(obj);

  res.send(p); // $ Alert
  res.send(other.p); // $ Alert
});

const serializeJavaScript = require('serialize-javascript');

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ Source

  var serialized = serializeJavaScript(p);

  res.send(serialized);
  
  var unsafe = serializeJavaScript(p, {unsafe: true});

  res.send(unsafe); // $ Alert
});

const fclone = require('fclone');

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ Source

  var obj = {};
  obj.p = p;
  var other = fclone(obj);

  res.send(p); // $ Alert
  res.send(other.p); // $ Alert
});

const jc = require('json-cycle');
app.get('/baz', function(req, res) {
  let { p } = req.params; // $ Source

  var obj = {};
  obj.p = p;
  var other = jc.retrocycle(jc.decycle(obj));

  res.send(p); // $ Alert
  res.send(other.p); // $ Alert
});

const sortKeys = require('sort-keys');

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ Source

  var obj = {};
  obj.p = p;
  var other = sortKeys(obj);

  res.send(p); // $ Alert
  res.send(other.p); // $ Alert
});

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ MISSING: Source

  var serialized = serializeJavaScript(p);

  res.send(serialized);
  
  var unsafe = serializeJavaScript({someProperty: p}, {unsafe: true});

  res.send(unsafe); // $ MISSING: Alert
});

app.get('/baz', function(req, res) {
  let { p } = req.params; // $ MISSING: Source

  var serialized = serializeJavaScript(p);

  res.send(serialized);
  let obj = {someProperty: p};
  var unsafe = serializeJavaScript(obj, {unsafe: true});

  res.send(unsafe); // $ MISSING: Alert
});
