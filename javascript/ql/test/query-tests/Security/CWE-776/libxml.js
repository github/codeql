const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  libxmljs.parseXml(req.param("some-xml")); // $ Alert - libxml expands internal general entities by default
});
