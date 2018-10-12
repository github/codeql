'use strict';
const Express = require('express');
const BodyParser = require('body-parser');
const Mongoose = require('mongoose');
Mongoose.Promise = global.Promise;
Mongoose.connect('mongodb://localhost/injectable1');

const app = Express();
app.use(BodyParser.json());

const Document = Mongoose.model('Document', {
    title: {
        type: String,
        unique: true
    },
    type: String
});

app.post('/documents/find', (req, res) => {
    const query = {};
    query.title = req.body.title;

    // NOT OK: query is tainted by user-provided object value
    Document.aggregate('type', query);

    // NOT OK: query is tainted by user-provided object value
    Document.count(query);

    // NOT OK: query is tainted by user-provided object value
    Document.deleteMany(query);

    // NOT OK: query is tainted by user-provided object value
    Document.deleteOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.distinct('type', query);

    // NOT OK: query is tainted by user-provided object value
    Document.find(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndDelete(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndRemove(query);

    // NOT OK: query is tainted by user-provided object value
    Document.findOneAndUpdate(query);

    // NOT OK: query is tainted by user-provided object value
    Document.replaceOne(query);

    // NOT OK: query is tainted by user-provided object value
    Document.update(query);

    // NOT OK: query is tainted by user-provided object value
    Document.updateMany(query);

    // NOT OK: query is tainted by user-provided object value
    Document.updateOne(query);
});

