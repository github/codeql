const jsyaml = require("js-yaml");

function requestHandler(req, res) {
  let data = jsyaml.safeLoad(req.params.data);
  // ...
}
