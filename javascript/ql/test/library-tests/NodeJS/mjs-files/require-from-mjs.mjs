var lib1 = require('./depend-on-me'); // FAILS: require is not available
var lib1 = require('./depend-on-me.js'); // FAILS: require is not available
var lib3 = require('./depend-on-me.mjs'); // FAILS: require is not available