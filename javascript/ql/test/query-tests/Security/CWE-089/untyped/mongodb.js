const express = require('express'),
      mongodb = require('mongodb'),
      bodyParser = require('body-parser');

const MongoClient = mongodb.MongoClient;

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.body.title; // $ Source
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      doc.find(query); // $ Alert - query is tainted by user-provided object value

      // OK - user-data is coerced to a string
      doc.find({ title: '' + query.body.title });

      // OK - throws unless user-data is a string
      doc.find({ title: query.body.title.substr(1) });

      let title = req.body.title; // $ Source
      if (typeof title === "string") {
        // OK - input checked to be a string
        doc.find({ title: title });

        doc.find({ title: JSON.parse(title) }); // $ Alert - input is parsed as JSON after string check
      }
    });
});

app.get('/:id', (req, res) => {
    let query = { id: req.param.id };
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      // OK - query is tainted, but only by string value
      doc.find(query);
    });
});

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.query.title; // $ Source
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
      let doc = db.collection('doc');

      doc.find(query); // $ Alert - query is tainted by user-provided object value
    });
});

app.post('/documents/find', (req, res) => {
	const query = {};
	query.title = req.query.title; // $ Source
	MongoClient.connect('mongodb://localhost:27017/test', (err, client) => {
		let doc = client.db("MASTER").collection('doc');

		doc.find(query); // $ Alert - query is tainted by user-provided object value
	});
});

app.post("/logs/count-by-tag", (req, res) => {
  let tag = req.query.tag; // $ Source

  MongoClient.connect(process.env.DB_URL, {}, (err, client) => {
    client
      .db(process.env.DB_NAME)
      .collection("logs")
      .count({ tags: tag }); // $ Alert - query is tainted by user-provided object value
  });

  let importedDbo = require("./dbo.js");
  importedDbo
    .db()
    .collection("logs")
    .count({ tags: tag }); // $ Alert - query is tainted by user-provided object value
});


app.get('/:id', (req, res) => {
  useParams(req.param);
});
function useParams(params) {
  let query = { id: params.id };
  MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
    let doc = db.collection('doc');

    // OK - query is tainted, but only by string value
    doc.find(query);
  });
}

app.post('/documents/find', (req, res) => {
  useQuery(req.query);
});
function useQuery(queries) {
  const query = {};
  query.title = queries.title; // $ Source
  MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
    let doc = db.collection('doc');

    doc.find(query); // $ Alert - query is tainted by user-provided object value
  });
}