const express = require('express');
const libxmljs = require('libxmljs');

express().get('/some/path', function(req) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true });
});

express().post('/some/path', function(req, res) {
  // NOT OK: unguarded entity expansion
  libxmljs.parseXml(req.param("some-xml"), { noent: true });

  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.param("some-xml"), {noent:true})
  // NOT OK: unguarded entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), {noent:true})
  
  // OK - no entity expansion
  libxmljs.parseXmlString(req.files.products.data.toString('utf8'), {noent:false})
});
