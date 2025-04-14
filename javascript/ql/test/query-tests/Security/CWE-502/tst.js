const jsyaml = require("js-yaml");

var express = require('express');
var app = express();
app.post('/store/:id', function(req, res) {
  let data;
  data = jsyaml.load(req.params.data);
  data = jsyaml.loadAll(req.params.data);
  data = jsyaml.safeLoad(req.params.data);
  data = jsyaml.safeLoadAll(req.params.data);

  let unsafeConfig = { schema: jsyaml.DEFAULT_FULL_SCHEMA };
  data = jsyaml.load(req.params.data, unsafeConfig); // $ Alert
  data = jsyaml.loadAll(req.params.data, unsafeConfig); // $ Alert
  data = jsyaml.safeLoad(req.params.data, unsafeConfig); // $ Alert
  data = jsyaml.safeLoadAll(req.params.data, unsafeConfig); // $ Alert

  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA });

  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').all) }); // $ Alert
  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').function) }); // $ Alert
  data = jsyaml.load(req.params.data, { schema: jsyaml.DEFAULT_SCHEMA.extend(require('js-yaml-js-types').undefined) });

  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').all.extend(jsyaml.DEFAULT_SCHEMA) }); // $ Alert
  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').function.extend(jsyaml.DEFAULT_SCHEMA) }); // $ Alert
  data = jsyaml.load(req.params.data, { schema: require('js-yaml-js-types').undefined.extend(jsyaml.DEFAULT_SCHEMA) });
});
