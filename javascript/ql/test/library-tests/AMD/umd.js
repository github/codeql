(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['./a', './dir/b'], factory);
    } else {
        // Browser globals
        root.amdWeb = factory(root.b);
    }
}(this, function (a, b) {
    return {
        bar: a.foo,
        foo: b.bar
    };
}));