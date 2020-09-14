const foo = require("foo");

while(foo)
  foo = foo.foo; /* use (member foo (member exports (module foo))) */ /* use (member foo (member foo (member exports (module foo)))) */
