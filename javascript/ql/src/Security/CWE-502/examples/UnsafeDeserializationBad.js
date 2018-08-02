const jsyaml = require("js-yaml");

function requestHandler(req, res) {
  let data = jsyaml.load(req.params.data);
  // ...
}
