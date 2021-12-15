const { pool } = require("./postgres1");

pool.connect((err, client, done) => {
    client.query('SELECT $1::int AS number', ['1'], function(err, result) {
    });
});
