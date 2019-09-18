const express = require('express'),
      mongodb = require('mongodb'),
      bodyParser = require('body-parser');

const MongoClient = mongodb.MongoClient;

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.body.title;
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // NOT OK: query is tainted by user-provided object value
      doc.find(query);

      // OK: user-data is coerced to a string
      doc.find({ title: '' + query.body.title });

      // OK: throws unless user-data is a string
      doc.find({ title: query.body.title.substr(1) });

      let title = req.body.title;
      if (typeof title === "string") {
        // OK: input checked to be a string
        doc.find({ title: title });

        // NOT OK: input is parsed as JSON after string check
        doc.find({ title: JSON.parse(title) });
      }
    });
});

app.get('/:id', (req, res) => {
    let query = { id: req.param.id };
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // OK: query is tainted, but only by string value
      doc.find(query);
    });
});

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.query.title;
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // NOT OK: query is tainted by user-provided object value
      doc.find(query);
    });
});
