var foo = require('./b').foo,
    bar = require('./c').bar,
    sneaky = require('./d').sneaky;

require('./g').baz;
require('./h').baz;
require('./n').foo;
