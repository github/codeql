// a.js
var b = require('./b');

var title = "Ms";

function example() {
	return title + " " + b.fullName;
}

exports.firstName = "Ada";

// b.js
var a = require('./a');

var lastName = "Lovelace";

exports.fullName = a.firstName + " " + lastName;