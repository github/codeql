char * create (int arg) {
    if (arg > 42) {
        // this function may return NULL
        return NULL;
    }
    char * r = malloc(arg);
    snprintf(r, arg -1, "Hello");
    return r;
}

void process(char *str) {
    // str is dereferenced
    if (str[0] == 'H') {
        printf("Hello H\n");
    }
}

void test(int arg) {
    // first function returns a pointer that may be NULL
    char *str = create(arg);
    // str is not checked for nullness before being passed to process function
    process(str);
}
