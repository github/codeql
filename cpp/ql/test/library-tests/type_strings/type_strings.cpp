// Compilable with:
// gcc -c type_strings.cpp

void (*functionPtrReturningVoidWithVoidArgument)(void);
int (*functionPtrReturningIntWithIntAndCharArguments)(int, char);
void (*arrayOfTenFunctionPtrsReturningVoidWithIntArgument[10])(int);

class Foo {
    public:
        Foo (int i){ }
        char f(int x, int y) { return 'x'; }
};

Foo *fooPointer;
char (Foo::*fPointer)(int x, int y);

char someFun(int x, int y) {
    return 'c';
}

void test(void) {
    char c;
    char (*fp)(int, int) = &someFun;
    char (&fp2)(int, int) = someFun;
    c = fp(4, 5);
    c = (*fp)(4, 5);
    c = (*(*fp))(4, 5);
    c = (*(*(*fp)))(4, 5);
    c = (***fp)(4, 5);
    c = fp2(4, 5);
    c = (*fp2)(4, 5);
    c = (***fp2)(4, 5);
}

int xs[10][20][30];

