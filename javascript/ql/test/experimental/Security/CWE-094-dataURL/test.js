const { Worker } = require('node:worker_threads');
var app = require('express')();

app.post('/path', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    let payloadURL = new URL(payload + sth)
    // NOT OK
    new Worker(payloadURL);
    // NOT OK
    payloadURL = new URL(payload + sth)
    new Worker(payloadURL);
    // OK
    payloadURL = new URL(sth + payload)
    new Worker(payloadURL);
});

app.post('/path2', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    // NOT OK
    await import(payload)
    // NOT OK
    await import(payload + sth)
    // OK
    await import(sth + payload)
});

