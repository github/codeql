const cp = require("child_process");

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - this function is exported from `amd.js`
};