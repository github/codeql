const express = require("express"),
  minimongo = require("minimongo"),
  bodyParser = require("body-parser");

var LocalDb = minimongo.MemoryDb,
  db = new LocalDb(),
  doc = db.myDocs;

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post("/documents/find", (req, res) => {
  const query = {};
  query.title = req.body.title;

  // NOT OK: query is tainted by user-provided object value
  doc.find(query);
});
