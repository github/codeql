const foo = require("foo");

foo.bar; // use=moduleImport("foo").getMember("exports").getMember("bar")
customLoad(foo, "baz") // use=moduleImport("foo").getMember("exports").getMember("baz")
