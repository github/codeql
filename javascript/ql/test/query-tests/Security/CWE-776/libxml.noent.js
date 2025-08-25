const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ Alert - unguarded entity expansion
});
