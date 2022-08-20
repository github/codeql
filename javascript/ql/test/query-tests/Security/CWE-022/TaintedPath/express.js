var express = require("express"),
  fileUpload = require("express-fileupload");

let app = express();
app.use(fileUpload());

app.get("/some/path", function (req, res) {
  req.files.foo.mv(req.query.bar);
});
