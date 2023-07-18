const app = require("express")();

function isLocalUrl(url) {
  return url.startsWith("/") && !url.startsWith("//") && !url.startsWith("/\\");
}

app.get('/redirect', function(req, res) {
  // GOOD: check that we don't redirect to a different host
  let target = req.params["target"];
  if (isLocalUrl(target)) {
    res.redirect(target);
  } else {
    res.redirect("/");
  }
});