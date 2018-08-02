
void printf(char *str, int a, int b);
typedef void (^voidBlock)(void);
voidBlock Block_copy(voidBlock);

int x;

void (^b1)(void);
void (^b2)(void);
void (^b3)(void);

void f(void) {
    __block int y;

    x = 1;
    y = 2;

    b1 = Block_copy(^ void (void) {
        printf("%d %d\n", x, y);
    });

    b2 = Block_copy(^ void (void) {
        x = 3;
        y = 4;
    });
}

int main(void) {
    f();
    b1(); // 1 2
    b2();
    b1(); // 3 4
    b3 = b1;
    f();
    b3(); // 1 4 (global x is reset, still using the old y)
    b1(); // 1 2 (using the new y)
    b2();
    b1(); // 3 4
    return 0;
}

