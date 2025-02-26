var cp = require("child_process")

module.exports = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink - is imported from main module.
};

module.exports.foo = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink - is imported from main module.
}; 