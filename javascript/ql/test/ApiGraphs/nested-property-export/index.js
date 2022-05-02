module.exports.foo = function (x) { /* use=moduleImport("nested-property-export").getMember("exports").getMember("foo").getParameter(0) */
    return x;
};

module.exports.foo.bar = function (y) { /* use=moduleImport("nested-property-export").getMember("exports").getMember("foo").getMember("bar").getParameter(0) */
    return y;
};
