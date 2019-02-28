let mysql = require('mysql');
let express = require('express');

let connection = mysql.createConnection();

let app = express();

app.get('/data', (req, res) => {
    connection.query('SELECT * FROM posts', (e, data) => {
	    res.send(data);
    });
});

function setup(c) {
    app.get('/data', (req, res) => {
	    c.query('SELECT * FROM posts', (e, data) => {
	        res.send(data);
	    });
	});
}

setup(connection);
