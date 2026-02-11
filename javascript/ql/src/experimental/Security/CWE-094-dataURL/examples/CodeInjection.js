const { Worker } = require('node:worker_threads');
var app = require('express')();

app.post('/path', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    const payloadURL = new URL(payload)
    new Worker(payloadURL);
});

app.post('/path2', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    await import(payload)
});

