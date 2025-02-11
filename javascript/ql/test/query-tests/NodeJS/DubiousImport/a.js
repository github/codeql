var foo = require('./b').foo, // $ TODO-SPURIOUS: Alert
    bar = require('./c').bar,
    sneaky = require('./d').sneaky;

require('./g').baz;
require('./h').baz;
require('./n').foo;
