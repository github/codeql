const app = require("express")();

function isLocalUrl(path) {
  try {
    return (
      // TODO: consider substituting your own domain for example.com
      new URL(path, "https://example.com").origin === "https://example.com"
    );
  } catch (e) {
    return false;
  }
}

app.get("/redirect", function (req, res) {
  // GOOD: check that we don't redirect to a different host
  let target = req.query["target"];
  if (isLocalUrl(target)) {
    res.redirect(target);
  } else {
    res.redirect("/");
  }
});
