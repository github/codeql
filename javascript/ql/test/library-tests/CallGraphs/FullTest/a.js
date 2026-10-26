import foo, { bar, qux } from './b';
foo();  // complete callee information
bar();  // complete callee information
qux();  // complete callee information

import baz from 'c';
baz();  // incomplete callee information: it is unclear what `c` resolves to