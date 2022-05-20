const foo = require("foo");

while(foo)
  foo = foo.foo; /* use=moduleImport("foo").getMember("exports").getMember("foo") */ /* use=moduleImport("foo").getMember("exports").getMember("foo").getMember("foo") */
