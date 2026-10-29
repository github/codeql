typedef struct Names {
    char first[100];
    char last[100];
} Names;

int doFoo(Names n) { //wrong: n is passed by value (meaning the entire structure
                     //is copied onto the stack, instead of just a pointer)
    ...
}

int doBar(const Names &n) { //better, only a reference is passed
    ...
}
