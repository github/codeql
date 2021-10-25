const app = require("express")(),
  expat = require("node-expat");

app.post("upload", (req, res) => {
  let xmlSrc = req.body,
    parser = new expat.Parser();
  parser.on("startElement", handleStart);
  parser.on("text", handleText);
  parser.write(xmlSrc);
});
