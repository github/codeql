const express = require("express");
const fileUpload = require("express-fileupload");
const path = require("path");

let app = express();
app.use(fileUpload());

app.get("/some/path/1", function (req, res) {
  req.files.foo.mv(req.query.bar.replace(/\.\.\//g, "")); // NOT OK, replacing a posix path segment is not safe on win32.
  res.status(200);
});

app.get("/some/path/2", function (req, res) {
  const p = req.query.bar;
  if (['foo.txt', 'bar.txt'].includes(p)) { // a valid sanitizer, even on windows
    req.files.foo.mv(p); // OK, because sanitized
  }
  res.status(200);
});

app.get("/some/path/3", function (req, res) {
  const workdir = "C:\\workdir"
  const p = path.join(workdir, req.query.filename);
  if (path.relative(workdir, p).startsWith("..")) {
    res.status(400);
  } else {
    req.files.foo.mv(p); // NOT OK (but would be on unix).
    res.status(200);
  }
});

app.get("/some/path/4", function (req, res) {
  const p = path.join('.', req.query.filename);
  if (!p.startsWith('..')) {
    req.files.foo.mv(p); // NOT OK because p could be C:\\foo.txt - but would be OK on posix
    res.status(200);
  } else {
    res.status(400);
  }
});
