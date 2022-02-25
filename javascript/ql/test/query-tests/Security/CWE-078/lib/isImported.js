// is imported from lib.js

const cp = require("child_process");

module.exports.thisMethodIsImported = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
}