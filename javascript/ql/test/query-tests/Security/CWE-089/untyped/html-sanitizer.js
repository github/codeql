const route = require('koa-route');
const Koa = require('koa');
const mysql = require('mysql2');
const app = new Koa();
const xss = require('xss');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'test'
});

app.use(route.get('/test1', (context, param1) => {
    param1 = xss(param1)
    connection.query(
        `SELECT * FROM \`table\` WHERE \`name\` =` + param1, // NOT OK
    );
}));
