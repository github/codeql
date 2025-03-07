function merge(dst, src) {
    for (let key in src) { // $ Source
        if (!src.hasOwnProperty(key)) continue;
        if (isObject(dst[key])) {
            merge(dst[key], src[key]);
        } else {
            dst[key] = src[key]; // $ Alert
        }
    }
}
