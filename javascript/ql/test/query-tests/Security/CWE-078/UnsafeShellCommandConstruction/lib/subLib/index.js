var cp = require("child_process")

module.exports = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert - functions exported as part of a submodule are also flagged.
};

module.exports.foo = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert - this is being called explicitly from child_process-test.js
};

module.exports.amd = require("./amd.js");

module.exports.arrToShell = function (cmd, arr) { // $ Source
    cp.spawn("echo", arr, {shell: true}); // $ Alert
}
