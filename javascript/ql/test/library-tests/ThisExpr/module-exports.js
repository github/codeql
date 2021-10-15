var fs = require('fs');

this;
exports.foo = function() { this; };
module.exports.bar = function() { this; };
exports.baz = () => this;
module.exports.qux = () => this;
