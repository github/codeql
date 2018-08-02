// OK: use of `exports` as shorthand for `module.exports`
exports = {};
exports.a = 23;
module.exports = exports;
exports.b = 32; 
