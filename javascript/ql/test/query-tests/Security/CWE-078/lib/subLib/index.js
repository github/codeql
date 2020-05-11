var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // OK - this file belongs in a sub-"module", and is not the primary exported module.
};