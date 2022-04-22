anotherUnknownFunction().foo = 42; /* MISSING: def=moduleExport("imprecise-export").getMember("exports").getMember("foo") */

module.exports = unknownFunction();
