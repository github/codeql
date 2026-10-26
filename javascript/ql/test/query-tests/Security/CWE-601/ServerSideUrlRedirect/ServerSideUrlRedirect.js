const app = require("express")();

app.get("/redirect", function (req, res) {
  res.redirect(req.query["target"]); // $ Alert - a request parameter is incorporated without validation into a URL redirect
});
