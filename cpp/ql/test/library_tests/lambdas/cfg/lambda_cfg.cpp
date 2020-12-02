// Compilable with:
// g++   -DCOMPILABLE_TEST -std=c++0x lambda_cfg.cpp -o lambda_cfg
// clang -DCOMPILABLE_TEST -std=c++0x lambda_cfg.cpp -o lambda_cfg

#ifdef COMPILABLE_TEST
#include <stdio.h>
#else
void printf(char *str, int x, int y);
#endif

int main(void) {
    auto myLambda = [] (int x, int y) -> int {
        int z;
        printf("Running with %d and %d\n", x, y);
        z = x + y;
        printf("Returning %d %d\n", z, z);
        return z;
    };

    printf("Some results: %d %d\n", myLambda(5, 6), myLambda(7, 8));

    return 0;
}

