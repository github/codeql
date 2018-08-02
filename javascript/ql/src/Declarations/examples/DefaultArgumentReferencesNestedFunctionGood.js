function defaultVal(x) {
    return x+19;
}

function f(x, y = defaultVal(x)) {
    return x*y;
}
