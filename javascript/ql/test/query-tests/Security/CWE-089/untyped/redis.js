
const redis = require("redis");
const client = redis.createClient();

const Express = require('express');
const app = Express();
app.use(require('body-parser').json());

app.post('/documents/find', (req, res) => {
    client.set(req.body.key, "value"); // NOT OK

    var key = req.body.key;
    if (typeof key === "string") {
        client.set(key, "value"); // OK
        client.set(["key", "value"]);
    }  

    client.set(key, "value"); // NOT OK
    client.hmset("key", "field", "value", key, "value2"); // NOT OK

    // chain commands
    client
        .multi()
        .set("constant", "value")
        .set(key, "value") // NOT OK
        .get(key) // OK
        .exec(function (err, replies) { });

    client.duplicate((err, newClient) => {
        newClient.set(key, "value"); // NOT OK
    });
    client.duplicate().set(key, "value"); // NOT OK
});


import { promisify } from 'util';
app.post('/documents/find', (req, res) => {
    const key = req.body.key;
    client.set(key, "value"); // NOT OK

    const setAsync = promisify(client.set).bind(client);

    const foo1 = setAsync(key, "value"); // NOT OK

    client.setAsync = promisify(client.set);
    const foo2 = client.setAsync(key, "value"); // NOT OK

    client.unrelated = promisify(() => {});
    const foo3 = client.unrelated(key, "value"); // OK

    const unrelated = promisify(client.foobar).bind(client);
    const foo4 = unrelated(key, "value"); // OK
});