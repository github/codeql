const express = require('express');
const expat = require('node-expat');

express().get('/some/path', function(req) {
  // OK: expat does not expands external entities
  var parser = new expat.Parser();
  parser.write(req.param("some-xml"));
});
