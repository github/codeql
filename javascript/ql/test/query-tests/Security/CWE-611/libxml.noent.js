const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function (req) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ BAD
});

express().post('/some/path', function (req, res) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ BAD

  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.param("some-xml"), { noent: true }) // $ BAD
  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: true }) // $ BAD

  // OK - no entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: false })
});
