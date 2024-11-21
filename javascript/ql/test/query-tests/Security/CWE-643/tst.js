const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let tainted = req.param("userName"); // $ Source
  xpath.parse(tainted); // $ Alert
  xpath.select(tainted); // $ Alert
  xpath.select1(tainted); // $ Alert
  let expr = xpath.useNamespaces(map);
  expr(tainted); // $ Alert
});
