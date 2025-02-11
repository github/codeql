function f(x, y = defaultVal(x)) { // $ TODO-SPURIOUS: Alert
    function defaultVal(x) {
        return x+19;
    }
    return x*y;
}
