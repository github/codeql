var express = require('express');

var app = express();
var myObj = {}

app.get('/user/:id', function(req, res) {
	myCoolLocalFct(req.query.userControlled);
	var prop = myCoolLocalFct(req.query.userControlled); // $ Source
	myObj[prop] = 23; // $ Alert
	myObj.prop = 23;
	var x = myObj[prop]; // OK - flagged by different query
	x(23);
	delete myObj[prop]; // $ Alert
	Object.defineProperty(myObj, prop, {value: 24}); // $ Alert
	var headers = {};
	headers[prop] = 42; // $ Alert
	res.set(headers);
	myCoolLocalFct[req.query.x](); // OK - flagged by method name injection
});

function myCoolLocalFct(x) {
	var result = x;
	return result.substring(0, result.length);

}