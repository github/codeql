require('./sub/c');

// doesn't export anything
exports = { dumb: 72 };

// convoluted export
(function() { return module.exports; }()).sneaky = 56;
