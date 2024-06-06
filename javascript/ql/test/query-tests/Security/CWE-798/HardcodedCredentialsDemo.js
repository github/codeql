(function () {
    const pg = require('pg');

    const client = new pg.Client({
        user: 'dbuser',  // OK
        host: 'database.server.com',
        database: 'mydb',
        password: 'hgfedcba',  // OK
        port: 3211,
    });
    client.connect();
})();
