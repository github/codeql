function f(x, y = defaultVal(x)) {
    function defaultVal(x) {
        return x+19;
    }
    return x*y;
}
