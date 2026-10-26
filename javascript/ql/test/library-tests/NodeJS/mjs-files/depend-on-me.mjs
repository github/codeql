exports.add = function add(x, y) { // FAILS: exports is not available
    return x + y;
}

export function add(x, y) {
    return x + y;
}