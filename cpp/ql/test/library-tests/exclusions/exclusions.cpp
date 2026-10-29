// This is the example from the QLDoc of `isFromMacroDefinition`.

void f(int);

#define M(x) f(x)

void useM(int y) {
  M(y + 1);
}
