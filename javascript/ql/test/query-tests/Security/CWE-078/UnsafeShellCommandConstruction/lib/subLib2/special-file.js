var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - the "files" directory points to this file.
};