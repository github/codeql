int f(int i, int j) {
    int result;
    if(i % 2 == 0) {
        result = i + j;
    }
    else {
        if(j % 2 == 0) {
            result = i * j;
        }
        else {
            result = i - j;
        }
    }
    return result;
}