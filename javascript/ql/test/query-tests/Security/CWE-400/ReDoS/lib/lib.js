var regexp = /a*b/;

module.exports = function (name) { // $ Source[js/polynomial-redos]
	regexp.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
};

function bar(reg, name) { // $ Source[js/polynomial-redos]
	/f*g/.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
}

if (typeof define !== 'undefined' && define.amd) { // AMD
    define([], function () {return bar});
}

module.exports.closure = require("./closure")

module.exports.func = function (conf) {
	return require("./indirect")
}

function id (x) {
	return x;
}
module.exports.id = id;

module.exports.safe = function (x) {
	var y = id("safe");
	/f*g/.test(y);
}

module.exports.useArguments = function () {
	usedWithArguments.apply(this, arguments); // $ Source[js/polynomial-redos]
}

function usedWithArguments(name) {
	/f*g/.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
}

module.exports.snapdragon = require("./snapdragon")

module.exports.foo = function (name) { // $ Source[js/polynomial-redos]
    var data1 = name.match(/f*g/); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]

    name = name.substr(1);
    var data2 = name.match(/f*g/); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
}

var indirectAssign = {};
module.exports.indirectAssign = indirectAssign;

Object.assign(indirectAssign, {
  myThing: function (name) { // $ Source[js/polynomial-redos]
    /f*g/.test(name); // $ Alert[js/polynomial-redos] Sink[js/polynomial-redos]
  },
});