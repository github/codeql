
// Standard "default" export semantics
import defaultImport from "./export-default-only.js";
sink(defaultImport.foo()); // $ hasValueFlow=default.foo

// Interop: the exported object can also refer to the default export
import * as ns from "./export-default-only.js";
sink(ns.default.foo()); // $ hasValueFlow=default.foo
sink(ns.foo()); // $ hasValueFlow=default.foo

// Standard named export semantics
import * as ns2 from "./export-named-only.js";
sink(ns2.foo()); // $ hasValueFlow=named.foo

// Interop: default-importing a module with only named exports gets the exported object
import namedAsDefault from "./export-named-only.js";
sink(namedAsDefault.foo()); // $ hasValueFlow=named.foo
