const util = require("util");

function f() {} // name: f

module.exports = util.deprecate(f, "don't use this function");
