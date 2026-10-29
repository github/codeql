const a = require('a'),
      b = require('b'),
      c = require('c'),
      d = require('d');

(function() {
	a.m1(x); // not flagged: not a dependency
	a.m2(x); // not flagged: not a dependency

	b.m1(x); // flagged

	c.m1(x); // not flagged: not a dependency
	c.m1(0, x); // not flagged: not a dependency

	d.m1(x); // flagged
});
