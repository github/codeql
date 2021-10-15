function extend(dest, src) {
    for (var p in src)
        dest[p] = src[p];
    return dest;
}