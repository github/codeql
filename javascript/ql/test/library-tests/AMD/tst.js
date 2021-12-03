define(['./a', './dir/b'], function(a, b, exports) {
    return {
        foo: a.foo,
        bar: b.bar
    };
});