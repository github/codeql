(function() {
    var v1 = (null)();
    var v2 = (null)?.();
    var v3 = (undefined)();
    var v4 = (undefined)?.();
    var v5 = (unknown)();
    var v6 = (unknown)?.();

    var f = unknown? undefined: function(){
        return 42;
    }
    var v7 = f();
    var v8 = f?.();
});
// semmle-extractor-options: --experimental
