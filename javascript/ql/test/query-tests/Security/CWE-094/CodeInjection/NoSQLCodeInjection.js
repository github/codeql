const express = require("express"),
  mongodb = require("mongodb"),
  bodyParser = require("body-parser");

const MongoClient = mongodb.MongoClient;

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post("/documents/find", (req, res) => {
  const query = {};
  query.title = req.body.title;
  MongoClient.connect("mongodb://localhost:27017/test", (err, db) => {
    let doc = db.collection("doc");

    doc.find(query); // NOT OK, but that is flagged by js/sql-injection [INCONSISTENCY]
    doc.find({ $where: req.body.query }); // NOT OK
    doc.find({ $where: "name = " + req.body.name }); // NOT OK

    function mkWhereObj() {
      return { $where: "name = " + req.body.name };  // NOT OK
    }

    doc.find(mkWhereObj()); // the alert location is in mkWhereObj.
  });
});
