// Compilable with:
// clang -std=c++11 -fblocks -c blocks.cpp

void (*functionPtrReturningVoidWithVoidArgument)(void);
int (*functionPtrReturningIntWithIntAndCharArguments)(int, char);
void (*arrayOfTenFunctionPtrsReturningVoidWithIntArgument[10])(int);

void (^blockReturningVoidWithVoidArgument)(void);
int (^blockReturningIntWithIntAndCharArguments)(int, char);
void (^arrayOfTenBlocksReturningVoidWithIntArgument[10])(int);

int x;

void f(void) {

    blockReturningVoidWithVoidArgument
      = ^ void (void) { x = 1; };

    blockReturningVoidWithVoidArgument
      = ^ (void) { x = 1; };

    blockReturningVoidWithVoidArgument
      = ^ { x = 1; };

    // Has an implicit "return;" so result type is void
    auto b1
      = ^ (int y, char z) { x = 1; };

    // Has no implicit "return;" but result type still void
    auto b2
      = ^ (int y, char z) { x = 1; while (1) { } };

    // Explicit return so result type char
    auto b3
      = ^ (int y, char z) { x = 1; return 'c'; };

    // Explicit return so result type char
    auto b4
      = ^ (int y, char z) { x = 1; if (1) { return 'c'; }; while (1) { } };

    // Also has an explicit return type
    auto b5
      = ^ char (int y, char z) { x = 1; return 'c'; };

    char c;

    b1(5, 'a');
    b2(5, 'a');
    c = b3(5, 'a');
    c = b4(5, 'a');
    c = b5(5, 'a');
}

struct Example {
  int four;
  int getFour() {
    return (^{ return four; })();
  }
};
