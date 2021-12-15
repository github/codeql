var parse = require('url-parse');

var r = parse(x, y);
r = r.set('foo', x);
r = r.toString('foo');
