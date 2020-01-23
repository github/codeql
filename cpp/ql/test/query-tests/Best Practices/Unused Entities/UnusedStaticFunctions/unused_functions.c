// semmle-extractor-options: -fblocks
#ifdef COMPILABLE_TEST
#include <stdio.h>
#else
void printf(char *str);
#endif

static void used_function(void) {
    printf("Gets run\n");
}

static void used_function2(void) {
    printf("Gets run 2\n");
}

static void unused_function(void) {
    printf("Doesn't get run\n");
}

static void unused_function2(void) {
    printf("Doesn't get run 2\n");
}

static void unused_function3(void) {
    printf("Doesn't get run 3\n");
    unused_function2();
}

static void __attribute__ ((constructor (300))) f300(void) {
    printf("Constructor 300 running\n");
}

static void __attribute__ ((constructor)) f(void) {
    printf("Constructor running\n");
}

int main(void) {
    printf("Main running\n");
    used_function();
    used_function2();
    int (^four)(void) = ^{ return 4; };
    return 0;
}

static void __attribute__ ((destructor)) g(void) {
    printf("Destructor running\n");
}

static void __attribute__ ((destructor (300))) g300(void) {
    printf("Destructor 300 running\n");
}

static void h2(void) {
}

static void __attribute__ ((used)) h1(void) {
  h2();
}

static void __attribute__ ((unused)) h3(void) {
}

static void h4(void) {
}
