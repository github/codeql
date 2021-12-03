
bool test_references(int a) {
    // x is a reference, so it only has one definition.
    int &x = a;
    int *ptr = &x;
    if (x > 10) {
        x--;
        if (x < 5) {
            return 1;
        }
    }
    return 0;
}
