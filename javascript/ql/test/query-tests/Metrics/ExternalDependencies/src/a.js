var lib1 = require('lib1');
var lib2 = require('lib2');

use(lib1);

var x = require('lib3').x;
console.log(x + x);