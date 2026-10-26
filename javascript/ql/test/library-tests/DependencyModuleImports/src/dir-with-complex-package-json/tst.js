const a = require('a'),
    c = require('c');


(function() {
	a.m1(x); // flagged

	c.m1(0, x); // flagged
});
