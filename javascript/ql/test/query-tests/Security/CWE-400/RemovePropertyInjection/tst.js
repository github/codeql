var express = require('express');

var app = express();
var myObj = {}

app.get('/user/:id', function(req, res) {
	myCoolLocalFct(req.query.userControlled);
	var prop = myCoolLocalFct(req.query.userControlled);
	myObj[prop] = 23; // NOT OK
	myObj.prop = 23; // OK
	var x = myObj[prop]; // NOT OK, but flagged by different query
	x(23);
	delete myObj[prop]; // NOT OK
	Object.defineProperty(myObj, prop, {value: 24}); // NOT OK
	var headers = {};
	headers[prop] = 42; // NOT OK
	res.set(headers);
	myCoolLocalFct[req.query.x](); // OK - flagged by method name injection
});

function myCoolLocalFct(x) {
	var result = x;
	return result.substring(0, result.length);

}