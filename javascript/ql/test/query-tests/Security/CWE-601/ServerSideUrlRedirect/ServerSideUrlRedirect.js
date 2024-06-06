const app = require("express")();

app.get("/redirect", function (req, res) {
  // BAD: a request parameter is incorporated without validation into a URL redirect
  res.redirect(req.query["target"]);
});
