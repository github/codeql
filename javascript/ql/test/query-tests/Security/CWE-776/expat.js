const express = require('express');
const expat = require('node-expat');

express().get('/some/path', function(req) {
  // NOT OK: expat expands internal entities by default
  var parser = new expat.Parser();
  parser.write(req.param("some-xml"));
});
