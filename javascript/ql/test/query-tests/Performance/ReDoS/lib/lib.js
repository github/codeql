var regexp = /a*b/;

module.exports = function (name) {
	regexp.test(name); // NOT OK
};

function bar(reg, name) {
	/f*g/.test(name); // NOT OK
}

if (typeof define !== 'undefined' && define.amd) { // AMD
    define([], function () {return bar});
}

module.exports.closure = require("./closure")