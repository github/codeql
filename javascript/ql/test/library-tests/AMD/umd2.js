; (function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ?
        module.exports = factory(require('./a'), require('./dir/b')) :
        typeof define === 'function' && define.amd ?
            define(['./a', './dir/b'], factory) :
            global.mymodule = factory(global.a, global.dir.b)
}(this, function (a, b) {
    return {
        bar: a.foo,
        foo: b.bar
    };
}));