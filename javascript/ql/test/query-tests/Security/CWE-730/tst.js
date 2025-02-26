const express = require('express');
const app = express();

app.get('/foo', (req, res) => {
    let data = req.query.data; // $ Source[js/regex-injection]
    new RegExp("^"+ data.name + "$", "i"); // $ Alert[js/regex-injection]
});
