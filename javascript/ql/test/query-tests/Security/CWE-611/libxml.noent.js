const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function (req) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ Alert
});

express().post('/some/path', function (req, res) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true }); // $ Alert

  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.param("some-xml"), { noent: true }) // $ Alert
  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: true })// $ Source=files $ Alert=files

  // OK - no entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), { noent: false })
});
