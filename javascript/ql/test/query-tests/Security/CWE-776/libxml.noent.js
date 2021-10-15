const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true });
});
