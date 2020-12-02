// Compilable with:
// clang -fblocks -c blocks.c

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
    void (^b1)(int, char)
      = ^ (int y, char z) { x = 1; };

    // Has no implicit "return;" but result type still void
    void (^b2)(int, char)
      = ^ (int y, char z) { x = 1; while (1) { } };

    // Explicit return so result type double
    double (^b3)(int, char)
      = ^ (int y, char z) { x = 1; return 0.5; };

    // Explicit return so result type double
    double (^b4)(int, char)
      = ^ (int y, char z) { x = 1; if (1) { return 0.5; }; while (1) { } };

    // Also has an explicit return type
    char (^b5)(int, char)
      = ^ char (int y, char z) { x = 1; return 'c'; };

    // Also has an explicit return type
    const char * (^b6)(int, char)
      = ^ const char * (int y, char z) { x = 1; return "str"; };

    // Also has an explicit return type
    const char * const * (^b7)(int, char)
      = ^ const char * const * (int y, char z) { x = 1; while (1) { }; };

    char c;
    double d;

    b1(5, 'a');
    b2(5, 'a');
    d = b3(5, 'a');
    d = b4(5, 'a');
    c = b5(5, 'a');
}

int (^fn)() = ^{
  return 4;
};

void g(void) {
  // Implicit parameter list
  int(^b1)(void) = ^ int { return 4; };
  
  // Exotic function pointer case
  typedef int (*pointerToFunctionThatReturnsIntWithCharArg)(char);
  pointerToFunctionThatReturnsIntWithCharArg functionPointer = 0;
  pointerToFunctionThatReturnsIntWithCharArg (^b2)(float) = ^int(*(float x))(char) { return functionPointer; };
}

void h(void) {
  typedef void(^B)(void);
  (B)^{};
  (B)^{};
}
