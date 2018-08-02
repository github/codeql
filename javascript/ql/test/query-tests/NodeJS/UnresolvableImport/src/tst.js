require('fs');    // OK: there is an externs file for it
require('other'); // NOT OK: there is an externs file, but it is not a Node.js module
require('foo');   // OK: declared as a dependency
require('bar/sub'); // OK: 'bar' declared as a dependency
require('./local'); // OK: local import
require('/global'); // OK: global import
require('mod');     // NOT OK
require('undeclared'); // NOT OK
require('jade!./template.jade'); // OK: WebPack loader
require('imports?$=jquery!./m.js'); // OK: WebPack shim
require('react'); // OK: peer dependency