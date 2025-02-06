var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // $ Alert - the "files" directory points to this file.
};