const express = require("express"),
      bodyParser = require("body-parser"),
      db = require('./marsdb-flow-from');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post("/documents/find", (req, res) => {
  const query = {};
  query.title = req.body.title;

  // NOT OK: query is tainted by user-provided object value
  db.myDoc.find(query);
});
