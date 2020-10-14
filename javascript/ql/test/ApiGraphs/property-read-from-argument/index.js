exports.assertNotNull = function (x) {
    if (x === null)
        throw new TypeError();
}

exports.foo = function(x) {
    exports.assertNotNull(x);
    sink(x.f); /* !use (member f (parameter 0 (member assertNotNull (member exports (module property-read-from-argument))))) */ /* use (member f (parameter 0 (member foo (member exports (module property-read-from-argument))))) */
}
