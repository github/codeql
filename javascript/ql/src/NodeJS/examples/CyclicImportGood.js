// a.js
var b = require('./b');

var title = "Ms";

function example() {
  return title + " " + b.fullName;
}

// b.js
var firstName = "Ada",
    lastName = "Lovelace";

exports.fullName = firstName + " " + lastName;
