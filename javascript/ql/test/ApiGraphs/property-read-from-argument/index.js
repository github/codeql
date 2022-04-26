exports.assertNotNull = function (x) {
    if (x === null)
        throw new TypeError();
}

exports.foo = function(x) {
    exports.assertNotNull(x);
    sink(x.f); /* MISSING: use=moduleImport("property-read-from-argument").getMember("exports").getMember("assertNotNull").getParameter(0).getMember("f") */ /* use=moduleImport("property-read-from-argument").getMember("exports").getMember("foo").getParameter(0).getMember("f") */
}
