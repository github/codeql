var express = require('express');

var fs = require('fs');
var child_process = require('child_process');
var mysql = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'me',
  password : 'secret',
  database : 'my_db'
});
connection.connect();
 
function expensiveHandler1(req, res) { login(); }
function expensiveHandler2(req, res) { fs.writeFileSync("log", "request"); }
function expensiveHandler3(req, res) { child_process.exec("/bin/true"); }
function expensiveHandler4(req, res) { connection.query('SELECT 1 + 1 AS solution'); }
function inexpensiveHandler(req, res) { res.send("Hi"); }

function mkSubRouter1() {
  var router = new express.Router();
  router.get('/:path', expensiveHandler1); // NOT OK
  return router;
}

function mkSubRouter2() {
  var router = new express.Router();
  router.get('/:path', expensiveHandler1); // OK
  return router;
}

var app1 = express();

// no rate limiting
app1.get('/:path', expensiveHandler1);  // NOT OK
app1.get('/:path', expensiveHandler2);  // NOT OK
app1.get('/:path', expensiveHandler3);  // NOT OK
app1.get('/:path', expensiveHandler4);  // NOT OK
app1.get('/:path', inexpensiveHandler); // OK
app1.use(mkSubRouter1());

// rate limiting using express-rate-limit
var RateLimit = require('express-rate-limit');
var limiter = new RateLimit();
app1.use(limiter);
app1.get('/:path', expensiveHandler1);  // OK
app1.get('/:path', expensiveHandler2);  // OK
app1.get('/:path', expensiveHandler3);  // OK
app1.get('/:path', expensiveHandler4);  // OK
app1.get('/:path', inexpensiveHandler); // OK
app1.use(mkSubRouter2());

// rate limiting using express-brute
var app2 = express();
var ExpressBrute = require('express-brute');
var bruteforce = new ExpressBrute();
app2.get('/:path', bruteforce.prevent, expensiveHandler1); // OK

// rate limiting using express-limiter
var app3 = express();
var limiter = require('express-limiter')(app3);
app3.get('/:path', expensiveHandler1); // OK

express().get('/:path', function(req, res) { verifyUser(req); });  // NOT OK
express().get('/:path', RateLimit(), function(req, res) { verifyUser(req); });  // OK

// rate limiting using rate-limiter-flexible
const { RateLimiterRedis } = require('rate-limiter-flexible');
const rateLimiter = new RateLimiterRedis();
const rateLimiterMiddleware = (req, res, next) => {
  rateLimiter.consume(req.ip).then(next).catch(res.status(429).send('rate limited'));
};
express().get('/:path', rateLimiterMiddleware, expensiveHandler1);
