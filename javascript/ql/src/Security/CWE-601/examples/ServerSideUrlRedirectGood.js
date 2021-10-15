const app = require("express")();

const VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html";

app.get('/some/path', function(req, res) {
  // GOOD: the request parameter is validated against a known fixed string
  let target = req.param("target");
  if (VALID_REDIRECT === target)
    res.redirect(target);
});
