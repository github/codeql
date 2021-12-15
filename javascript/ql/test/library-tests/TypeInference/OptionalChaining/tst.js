(function() {
    var v1 = (null)();
    var v2 = (null)?.();
    var v3 = (undefined)();
    var v4 = (undefined)?.();
    var v5 = (unknown)();
    var v6 = (unknown)?.();

    var f = unknown? undefined: function(){
        return 42;
    };
    var v7 = f();
    var v8 = f?.();

    var g = function(){
        return 42;
    };
    var v9 = g();
    var v10 = g?.();

    var h = undefined;
    var v11 = h();
    var v12 = h?.();
});
