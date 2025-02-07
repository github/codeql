// Adapted from the Node.js documentation
console.log('b starting');
exports.done = false;
var a = require('./a.js'); // $ TODO-SPURIOUS: Alert
console.log('in b, a.done = %j', a.done);
exports.done = true;
console.log('b done');
