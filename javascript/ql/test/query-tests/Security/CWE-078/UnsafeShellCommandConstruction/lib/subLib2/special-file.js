var cp = require("child_process")

module.exports = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink - the "files" directory points to this file.
};