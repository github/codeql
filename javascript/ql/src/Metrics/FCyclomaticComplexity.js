function f(i, j) {
    // start
    var result;
    if(i % 2 == 0) {
        // iEven
        result = i + j;
    }
    else {
        // iOdd
        if(j % 2 == 0) {
            // jEven
            result = i * j;
        }
        else {
            // jOdd
            result = i - j;
        }
    }
    return result;
    // end
}