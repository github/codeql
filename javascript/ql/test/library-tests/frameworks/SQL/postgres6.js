import pkg from 'pg';

const { Query, Client } = pkg;
const client = new Client({
    host: '127.0.0.1',
    port: 5432,
    database: 'testsqli',
    user: 'postgres'
})

const queryObj = {
    name: 'get-name',
    text: 'SELECT * FROM  "user" WHERE id=6'
}

await client.query(queryObj) // Already Implemented

new Query('SELECT * FROM  "user" WHERE id=7')
