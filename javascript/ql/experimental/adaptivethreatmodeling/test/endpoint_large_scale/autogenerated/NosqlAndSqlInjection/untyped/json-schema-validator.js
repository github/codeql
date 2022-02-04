import Ajv from 'ajv';
import express from 'express';
import { MongoClient } from 'mongodb';

const app = express();

const schema = {
    type: 'object',
    properties: {
        date: { type: 'string' },
        title: { type: 'string' },
    },
};
const ajv = new Ajv();
const checkSchema = ajv.compile(schema);

function validate(x) {
    return x != null;
}

app.post('/documents/find', (req, res) => {
    MongoClient.connect('mongodb://localhost:27017/test', (err, db) => {
        let doc = db.collection('doc');

        const query = JSON.parse(req.query.data);
        if (checkSchema(query)) {
            doc.find(query); // OK
        }
        if (ajv.validate(schema, query)) {
            doc.find(query); // OK
        }
        if (validate(query)) {
            doc.find(query); // NOT OK - validate() doesn't sanitize
        }
        doc.find(query); // NOT OK
    });
});
