const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let tainted = req.param("userName");
  xpath.parse(tainted); // NOT OK
  xpath.select(tainted); // NOT OK
  xpath.select1(tainted); // NOT OK
  let expr = xpath.useNamespaces(map);
  expr(tainted); // NOT OK
});
