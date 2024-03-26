const { Worker } = require('node:worker_threads');
var app = require('express')();

app.post('/path', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    let payloadURL = new URL(payload + sth) // NOT OK
    new Worker(payloadURL);

    payloadURL = new URL(payload + sth) // NOT OK
    new Worker(payloadURL);

    payloadURL = new URL(sth + payload) // OK
    new Worker(payloadURL);
});

app.post('/path2', async function (req, res) {
    const payload = req.query.queryParameter // like:  payload = 'data:text/javascript,console.log("hello!");//'
    await import(payload) // NOT OK
    await import(payload + sth) // NOT OK
    await import(sth + payload) // OK
});

