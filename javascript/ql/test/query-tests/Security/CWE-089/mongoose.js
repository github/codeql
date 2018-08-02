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
    Document.find(query);
});

