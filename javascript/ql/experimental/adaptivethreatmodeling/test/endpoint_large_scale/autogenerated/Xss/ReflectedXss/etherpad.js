let express = require('express');
let isVarName = require('is-var-name');
let app = express();

app.get("/some/path", (req, res) => {
  let response = "Hello, world!";

  if(req.query.jsonp && isVarName(req.query.jsonp))
    response = req.query.jsonp + "(" + response + ")";

  res.send(response);
});
