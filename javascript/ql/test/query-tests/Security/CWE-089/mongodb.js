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
