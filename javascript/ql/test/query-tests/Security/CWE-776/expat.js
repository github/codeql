const express = require('express');
const expat = require('node-expat');

express().get('/some/path', function(req) {
  var parser = new expat.Parser();
  parser.write(req.param("some-xml")); // $ Alert - expat expands internal entities by default
});
