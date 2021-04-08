define(['./a', './dir/b'], function(a, {bar}, exports) {
    return {
        foo: a.foo,
        bar: bar
    };
});