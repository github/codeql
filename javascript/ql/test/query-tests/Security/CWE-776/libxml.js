const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  // NOT OK: libxml expands internal general entities by default
  libxmljs.parseXml(req.param("some-xml"));
});
