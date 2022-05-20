var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - is imported from main module.
};

module.exports.foo = function (name) {
	cp.exec("rm -rf " + name); // NOT OK - is imported from main module.
}; 