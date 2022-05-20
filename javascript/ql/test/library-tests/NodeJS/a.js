var b = require('./b'),
	fs = require('fs'),
	c = require('./sub/c'),
	d = require('./sub/../d.js');

b.qux;
require('./sub/c').foo;
c.bar;
d.baz;
require(__dirname);
require(__dirname + '/e');
require('./sub' + '/' + 'c');

