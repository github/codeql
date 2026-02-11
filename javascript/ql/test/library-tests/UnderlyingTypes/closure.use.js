goog.module("closure.use")

const lib = goog.require("closure.lib");
const es = goog.require("closure.es");

/**
 * @param {lib.Foo} x
 */
function t1(x) { // $ hasUnderlyingType=closure.reexported.Foo hasUnderlyingType=closure.lib.Foo
}

/**
 * @param {es.Bar} x
 */
function t2(x) { // $ hasUnderlyingType=closure.reexported.Bar hasUnderlyingType=closure.es.Bar
}
