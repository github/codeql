var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // OK - this file belongs in a sub-"module", and is not the primary exported module.
};

module.exports.foo = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - this is being called explicitly from child_process-test.js
};