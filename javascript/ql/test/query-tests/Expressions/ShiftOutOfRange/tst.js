var n = 1<<40; // NOT OK
var n2 = BigInt(1) << 40n; // OK

// semmle-extractor-options: --experimental
