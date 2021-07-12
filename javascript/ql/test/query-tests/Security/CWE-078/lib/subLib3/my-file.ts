var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - functions exported as part of a submodule are also flagged.
};
