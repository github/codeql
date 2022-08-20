var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - functions exported as part of a submodule are also flagged.
};

module.exports.foo = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - this is being called explicitly from child_process-test.js
};

module.exports.amd = require("./amd.js");