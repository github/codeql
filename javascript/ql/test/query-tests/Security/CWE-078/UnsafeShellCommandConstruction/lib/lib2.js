var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // $ Alert - is imported from main module.
};

module.exports.foo = function (name) {
	cp.exec("rm -rf " + name); // $ Alert - is imported from main module.
}; 