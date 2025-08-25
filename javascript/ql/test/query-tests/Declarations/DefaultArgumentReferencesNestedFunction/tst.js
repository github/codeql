function f(x, y = defaultVal(x)) { // $ Alert
    function defaultVal(x) {
        return x+19;
    }
    return x*y;
}
