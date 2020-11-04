module.exports.foo = function (x) { /* use (parameter 0 (member foo (member exports (module nested-property-export)))) */
    return x;
};

module.exports.foo.bar = function (y) { /* use (parameter 0 (member bar (member foo (member exports (module nested-property-export))))) */
    return y;
};
