var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // OK, is not exported to a main-module. 
};