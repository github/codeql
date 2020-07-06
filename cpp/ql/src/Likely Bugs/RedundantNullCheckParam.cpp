void test(char *arg1, int *arg2) {
    if (arg1[0] == 'A') {
        if (arg2 != NULL) {
            *arg2 = 42;
        }
    }
    if (arg1[1] == 'B')
    {
        *arg2 = 54;
    }
}
