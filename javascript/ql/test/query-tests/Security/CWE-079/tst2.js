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
