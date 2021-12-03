var mysql      = require('mysql'),
    config     = require('./mysql-config.json');
mysql.createConnection(config);
connection.connect();
connection.end();