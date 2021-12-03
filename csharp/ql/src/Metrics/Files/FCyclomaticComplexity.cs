int f(int i, int j) {
    // start
    int result;
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
