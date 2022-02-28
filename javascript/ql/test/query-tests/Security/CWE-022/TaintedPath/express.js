var express = require("express"),
  fileUpload = require("express-fileupload");

let app = express();
app.use(fileUpload());

app.get("/some/path/1", function (req, res) {
  req.files.foo.mv(req.query.bar); // NOT OK
});

app.get("/some/path/2", function (req, res) {
  const p = path.join('.', req.query.filename);
  if (!p.startsWith('..')) {
    req.files.foo.mv(p); // OK (but not on windows)
    res.status(200);
  } else {
    res.status(400);
  }
});
