const express = require('express'),
      mongodb = require('mongodb'),
      bodyParser = require('body-parser');

const MongoClient = mongodb.MongoClient;

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.body.title;
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // OK: req.body is safe
      doc.find(query);
    });
});

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.query.title;
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // NOT OK: regardless of body parser, query value is still tainted
      doc.find(query);
    });
});
