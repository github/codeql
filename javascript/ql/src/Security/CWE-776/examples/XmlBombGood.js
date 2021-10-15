const app = require("express")(),
  sax = require("sax");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    parser = sax.parser(true);
  parser.onopentag = handleStart;
  parser.ontext = handleText;
  parser.write(xmlSrc);
});
