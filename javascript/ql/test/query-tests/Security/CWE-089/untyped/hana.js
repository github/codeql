const hana = require('@sap/hana-client');
const express = require('express');

const app = express();
const connectionParams = {};
app.post('/documents/find', (req, res) => {
    const conn = hana.createConnection();
    conn.connect(connectionParams, (err) => {
        let maliciousInput = req.body.data; // $ Source
        const query = `SELECT * FROM Users WHERE username = '${maliciousInput}'`;
        conn.exec(query, (err, rows) => {}); // $ Alert
        conn.disconnect();
    });

    conn.connect(connectionParams, (err) => {
        const maliciousInput = req.body.data; // $ Source
        const stmt = conn.prepare(`SELECT * FROM Test WHERE ID = ? AND username = ` + maliciousInput); // $ Alert
        stmt.exec([maliciousInput], (err, rows) => {}); // maliciousInput is treated as a parameter
        conn.disconnect();
    });

    conn.connect(connectionParams, (err) => {
        const maliciousInput = req.body.data; // $ Source
        var stmt = conn.prepare(`INSERT INTO Customers(ID, NAME) VALUES(?, ?) ` + maliciousInput); // $ Alert
        stmt.execBatch([[1, maliciousInput], [2, maliciousInput]], function(err, rows) {}); // maliciousInput is treated as a parameter
        conn.disconnect();
    });

    conn.connect(connectionParams, (err) => {
      const maliciousInput = req.body.data; // $ Source
      var stmt = conn.prepare("SELECT * FROM Customers WHERE ID >= ? AND ID < ?" + maliciousInput); // $ Alert
      stmt.execQuery([100, maliciousInput], function(err, rs) {}); // $ maliciousInput is treated as a parameter
      conn.disconnect();
    });
});

var hdbext = require('@sap/hdbext');
var express = require('express');
var dbStream = require('@sap/hana-client/extension/Stream');

var app1 = express();
const hanaConfig = {};
app1.use(hdbext.middleware(hanaConfig));

app1.get('/execute-query', function (req, res) {
  var client = req.db;
  let maliciousInput = req.body.data; // $ Source
  client.exec('SELECT * FROM DUMMY' + maliciousInput, function (err, rs) {}); // $ Alert

  dbStream.createProcStatement(client, 'CALL PROC_DUMMY (?, ?, ?, ?, ?)' + maliciousInput, function (err, stmt) { // $ Alert
    stmt.exec({ A: maliciousInput, B: 4 }, function (err, params, dummyRows, tablesRows) {}); // maliciousInput is treated as a parameter
  });

  hdbext.loadProcedure(client, null, 'PROC_DUMMY' + maliciousInput, function(err, sp) { // $ Alert
    sp(3, maliciousInput, function(err, parameters, dummyRows, tablesRows) {}); // maliciousInput is treated as a parameter
  });
});


var hdb = require('hdb');
const async = require('async');

const options = {};
const app2 = express();

app2.post('/documents/find', (req, res) => {
  var client = hdb.createClient(options);
  let maliciousInput = req.body.data; // $ Source

  client.connect(function onconnect(err) {
    async.series([client.exec.bind(client, "INSERT INTO NUMBERS VALUES (1, 'one')" + maliciousInput)], function (err) {}); // $ Alert

    client.exec('select * from DUMMY' + maliciousInput, function (err, rows) {}); // $ Alert
    client.exec('select * from DUMMY' + maliciousInput, options, function(err, rows) {}); // $ Alert

    client.prepare('select * from DUMMY where DUMMY = ?' + maliciousInput, function (err, statement){ // $ Alert
      statement.exec([maliciousInput], function (err, rows) {}); // maliciousInput is treated as a parameter
    });

    client.prepare('call PROC_DUMMY (?, ?, ?, ?, ?)' + maliciousInput, function(err, statement){ // $ Alert
      statement.exec({A: 3, B: maliciousInput}, function(err, parameters, dummyRows, tableRows) {}); 
    });

    client.execute('select A, B from TEST.NUMBERS order by A' + maliciousInput, function(err, rs) {}); // $ Alert
  });
});
