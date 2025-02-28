const cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // $ Alert Sink - functions exported as part of a submodule are also flagged.
};
