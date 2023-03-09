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

module.exports.func = function (conf) {
	return require("./indirect")
}

function id (x) {
	return x;
}
module.exports.id = id;

module.exports.safe = function (x) {
	var y = id("safe");
	/f*g/.test(y); // OK
}

module.exports.useArguments = function () {
	usedWithArguments.apply(this, arguments);
}

function usedWithArguments(name) {
	/f*g/.test(name); // NOT OK
}

module.exports.snapdragon = require("./snapdragon")

module.exports.foo = function (name) {
    var data1 = name.match(/f*g/); // NOT OK

    name = name.substr(1);
    var data2 = name.match(/f*g/); // NOT OK
}

var indirectAssign = {};
module.exports.indirectAssign = indirectAssign;

Object.assign(indirectAssign, {
  myThing: function (name) {
    /f*g/.test(name); // NOT OK
  },
});