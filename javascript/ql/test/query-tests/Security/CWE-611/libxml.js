const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  // OK: libxml does not expand entities by default
  libxmljs.parseXml(req.param("some-xml"));
});
