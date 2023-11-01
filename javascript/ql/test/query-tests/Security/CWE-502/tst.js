const jsyaml = require("js-yaml");

var express = require('express');
var app = express();
app.post('/store/:id', function(req, res) {
  let data;
  data = jsyaml.load(req.params.data); // OK
  data = jsyaml.loadAll(req.params.data); // OK
  data = jsyaml.safeLoad(req.params.data); // OK
  data = jsyaml.safeLoadAll(req.params.data); // OK

  let unsafeConfig = { schema: jsyaml.DEFAULT_FULL_SCHEMA };
  data = jsyaml.load(req.params.data, unsafeConfig); // NOT OK
  data = jsyaml.loadAll(req.params.data, unsafeConfig); // NOT OK
  data = jsyaml.safeLoad(req.params.data, unsafeConfig); // NOT OK
  data = jsyaml.safeLoadAll(req.params.data, unsafeConfig); // NOT OK

  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA }); // OK

  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').all) }); // NOT OK
  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').function) }); // NOT OK
  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').undefined) }); // OK

  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').all.extend(jsyaml.DEFAULT_SCHEMA) }); // NOT OK
  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').function.extend(jsyaml.DEFAULT_SCHEMA) }); // NOT OK
  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').undefined.extend(jsyaml.DEFAULT_SCHEMA) }); // OK
});
