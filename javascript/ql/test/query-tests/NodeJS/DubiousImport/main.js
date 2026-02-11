var b = require('./b'),
	c = require('./c'),
	d = require('./d');

b.foo; // $ Alert
c.bar;
d.sneaky;
b.prototype;
b.call();
require('./e').baz;
require('./f').tricky;

var fs = require('fs');
fs.rename('foo', 'bar', function() {});
fs.renmae('foo', 'bar', function() {}); // $ Alert
fs.move('foo', 'bar', function() {});

var k = require('./k');
k.foo;

var l = require('./l');
l.foo();
l.bar(); // $ Alert

require('./m').foo;

require('./export_getter').foo;