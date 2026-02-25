require('./file2.js').f1(source('file1.1'));

const m = require('./file2.js');
const c = new m.C();
c.f2(source('file1.2'));

require('./file2.js').f3(source('file1.3'));
require('./file2.js').f4(source('file1.4'));
require('./file2.js').f5(source('file1.5'));
require('./function-raw-export.js')(source('file1.6'));

sink(require('./file2.js').foo()); // $ hasValueFlow=reExported.foo
sink(require('./file2.js').bar()); // $ hasValueFlow=reExported.foo
sink(require('./bulk-exporting.js').foo()); // $ hasValueFlow=shadowing.foo
sink(require('./bulk-exporting.js').bar()); // $ hasValueFlow=reExported.foo
sink(require('./bulk-exporting.js').file2.foo()); // $ hasValueFlow=reExported.foo
sink(require('./bulk-exporting.js').file2.bar()); // $ hasValueFlow=reExported.foo
