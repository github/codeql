const jsyaml = require("js-yaml");

var express = require('express');
var app = express();
app.post('/store/:id', function(req, res) {
  let data;
  data = jsyaml.load(req.params.data); // NOT OK
  data = jsyaml.loadAll(req.params.data); // NOT OK
  data = jsyaml.safeLoad(req.params.data); // OK
  data = jsyaml.safeLoadAll(req.params.data); // OK
  let unsafeConfig = { schema: jsyaml.DEFAULT_FULL_SCHEMA };
  data = jsyaml.safeLoad(req.params.data, unsafeConfig); // NOT OK
  data = jsyaml.safeLoadAll(req.params.data, unsafeConfig); // NOT OK
});
