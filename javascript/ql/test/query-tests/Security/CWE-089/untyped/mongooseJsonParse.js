'use strict';
const Express = require('express');
const BodyParser = require('body-parser');
const Mongoose = require('mongoose');
Mongoose.Promise = global.Promise;
Mongoose.connect('mongodb://localhost/injectable1');

const app = Express();

const Document = Mongoose.model('Document', {
    title: {
        type: String,
        unique: true
    },
    type: String
});

app.get('/documents/find', (req, res) => {
    const query = {};
    query.title = JSON.parse(req.query.data).title;

    // NOT OK: query is tainted by user-provided object value
    Document.find(query);
});

