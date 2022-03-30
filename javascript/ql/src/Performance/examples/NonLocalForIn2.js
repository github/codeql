function combine(dest) {
    var p;

    function extend(src) {
        for (p in src)
            dest[p] = src[p];
    }

    for (var i=1; i<arguments.length; ++i)
        extend(arguments[i]);

    return dest;
}