const express = require('express');
const app = express();

app.get(/\/[a-zA-Z]+/, (req, res, next) => { // OK - regexp term is case insensitive
    next();
});

app.get('/foo', (req, res) => {
});
