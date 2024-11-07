const express = require('express');
const app = express();

app.get('/foo', (req, res) => {
    let data = req.query.data;
    new RegExp("^"+ data.name + "$", "i"); // NOT OK
});
