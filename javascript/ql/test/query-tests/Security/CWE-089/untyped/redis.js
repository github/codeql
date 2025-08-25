
const redis = require("redis");
const client = redis.createClient();

const Express = require('express');
const app = Express();
app.use(require('body-parser').json());

app.post('/documents/find', (req, res) => {
    client.set(req.body.key, "value"); // $ Alert

    var key = req.body.key; // $ Source
    if (typeof key === "string") {
        client.set(key, "value");
        client.set(["key", "value"]);
    }  

    client.set(key, "value"); // $ Alert
    client.hmset("key", "field", "value", key, "value2"); // $ Alert

    // chain commands
    client
        .multi()
        .set("constant", "value")
        .set(key, "value") // $ Alert
        .get(key)
        .exec(function (err, replies) { });

    client.duplicate((err, newClient) => {
        newClient.set(key, "value"); // $ Alert
    });
    client.duplicate().set(key, "value"); // $ Alert
});


import { promisify } from 'util';
app.post('/documents/find', (req, res) => {
    const key = req.body.key; // $ Source
    client.set(key, "value"); // $ Alert

    const setAsync = promisify(client.set).bind(client);

    const foo1 = setAsync(key, "value"); // $ Alert

    client.setAsync = promisify(client.set);
    const foo2 = client.setAsync(key, "value"); // $ Alert

    client.unrelated = promisify(() => {});
    const foo3 = client.unrelated(key, "value");

    const unrelated = promisify(client.foobar).bind(client);
    const foo4 = unrelated(key, "value");
});