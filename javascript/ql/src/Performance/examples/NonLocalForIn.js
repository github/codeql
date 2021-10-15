function extend(dest, src) {
    for (p in src)
        dest[p] = src[p];
    return dest;
}