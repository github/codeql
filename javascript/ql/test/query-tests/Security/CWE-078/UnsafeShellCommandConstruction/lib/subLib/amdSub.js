const cp = require("child_process");

module.exports = function (name) {
	cp.exec("rm -rf " + name); // $ Alert - this function is exported from `amd.js`
};