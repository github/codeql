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

        const query = JSON.parse(req.query.data); // $ Source
        if (checkSchema(query)) {
            doc.find(query);
        }
        if (ajv.validate(schema, query)) {
            doc.find(query);
        }
        if (validate(query)) {
            doc.find(query); // $ Alert - validate() doesn't sanitize
        }
        doc.find(query); // $ Alert
    });
});

import Joi from 'joi';

const joiSchema = Joi.object({
    date: Joi.string().required(),
    title: Joi.string().required()
}).with('date', 'title');

app.post('/documents/insert', (req, res) => {
    MongoClient.connect('mongodb://localhost:27017/test', async (err, db) => {
        let doc = db.collection('doc');

        const query = JSON.parse(req.query.data); // $ Source
        const validate = joiSchema.validate(query);
        if (!validate.error) {
            doc.find(query);
        } else {
            doc.find(query); // $ Alert
        }
        try {
            await joiSchema.validateAsync(query);
            doc.find(query); // $ SPURIOUS: Alert
        } catch (e) {
            doc.find(query); // $ Alert
        }
    });
});