const a = require('a'),
      b = require('b'),
      c = require('c'),
      d = require('d');

(function() {
	a.m1(x); // flagged
	a.m2(x); // not flagged: other method

	b.m1(x); // not flagged: early version

	c.m1(x); // not flagged: other argument
	c.m1(0, x); // flagged

	d.m1(x); // not flagged: late version
});
