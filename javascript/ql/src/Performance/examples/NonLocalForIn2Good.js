function combine(dest) {
    function extend(src) {
        for (var p in src)
            dest[p] = src[p];
    }

    for (var i=1; i<arguments.length; ++i)
        extend(arguments[i]);

    return dest;
}