const hana = require('@sap/hana-client');
const express = require('express');

const app = express();
const connectionParams = {};
const query = ``;
app.post('/documents/find', (req, res) => {
    const conn = hana.createConnection();
    conn.connect(connectionParams, (err) => {
        conn.exec(query, (err, rows) => { 
          document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
        }); 

        const stmt = conn.prepare(query);
        stmt.exec([0], (err, rows) => { 
          document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
        });
        stmt.execBatch([[1, "a"], [2, "b"]], function(err, rows) { 
          document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
        });
        stmt.execQuery([100, "a"], function(err, rs) { 
          document.body.innerHTML = rs[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
        });
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
  client.exec(query, function (err, rs) { 
    document.body.innerHTML = rs[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
  });

  dbStream.createProcStatement(client, query, function (err, stmt) {
    stmt.exec({ A: 1, B: 4 }, function (err, params, dummyRows, tablesRows) {
      document.body.innerHTML = dummyRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
      document.body.innerHTML = tablesRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
  });

  hdbext.loadProcedure(client, null, query, function(err, sp) {
    sp(3, maliciousInput, function(err, parameters, dummyRows, tablesRows) {
      document.body.innerHTML = dummyRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
      document.body.innerHTML = tablesRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
  });
});


var hdb = require('hdb');
const async = require('async');
const { q } = require('underscore.string');

const options = {};
const app2 = express();

app2.post('/documents/find', (req, res) => {
  var client = hdb.createClient(options);

  client.connect(function onconnect(err) {

    client.exec(query, function (err, rows) { 
      document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
    client.exec(query, options, function(err, rows) { 
      document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
    });

    client.prepare(query, function (err, statement){
      statement.exec([1], function (err, rows) { 
        document.body.innerHTML = rows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
      }); 
    });

    client.prepare(query, function(err, statement){
      statement.exec({A: 3, B: 1}, function(err, parameters, dummyRows, tableRows) {
        document.body.innerHTML = dummyRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
        document.body.innerHTML = tableRows[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
      }); 
    });

    client.execute(query, function(err, rs) { 
      document.body.innerHTML = rs[0].comment; // $ Alert[js/xss-additional-sources-dom-test]
    });
  });
});
