import 'dummy';

var x = process.env['foo']; // $ threat-source=environment
SINK(x); // $ hasFlow
