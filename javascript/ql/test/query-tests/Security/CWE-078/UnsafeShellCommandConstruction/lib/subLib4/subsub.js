const cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // $ Alert - functions exported as part of a submodule are also flagged.
};
