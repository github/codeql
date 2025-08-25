const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function (req) {
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ Alert - unguarded entity expansion
});

express().post('/some/path', function (req, res) {
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ Alert - unguarded entity expansion

  libxmljs.parseXmlString(req.param("some-xml"), { noent: true }) // $ Alert - unguarded entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: true })// $ Alert - unguarded entity expansion

  // OK - no entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: false })
});
