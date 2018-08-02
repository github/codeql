const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  // NOT OK: the SAX parser expands external entities by default
  const parser = new libxmljs.SaxPushParser();
  parser.push(req.param("some-xml"));
});
