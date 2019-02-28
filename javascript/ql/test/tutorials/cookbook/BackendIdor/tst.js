let express = require('express');
let request = require('request');

let app = express();
app.get('/messages/{userId}', (req, res) => {
    let userId = req.params.userId;
    request.post('https://backend.example.com/getMessages', {userId})
        .on('response', (resp) => res.end(resp))
        .on('error', (err) => res.status(500));
});

// semmle-extractor-options: --experimental
