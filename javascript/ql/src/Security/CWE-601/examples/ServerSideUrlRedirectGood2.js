const app = require("express")();

function isRelativePath(path) {
  return !/^(\w+:)?[/\\]{2}/.test(path);
}

app.get("/redirect", function (req, res) {
  // GOOD: check that we don't redirect to a different host
  let target = req.query["target"];
  if (isRelativePath(target)) {
    res.redirect(target);
  } else {
    res.redirect("/");
  }
});
