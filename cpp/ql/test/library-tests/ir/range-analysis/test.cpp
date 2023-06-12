#include "test_util.h"
  int f1(int x, int y) {
    if (x < 500) {
      if (x > 400) {
        range(x);  // $ range=>=401 range=<=499
        return x;
      }

      if (y - 2 == x && y > 300) { // $ overflow=-
        range(x + y);  // $ range=<=802 range=>=600
        return x + y;
      }

      if (x != y + 1) { // $ overflow=+
        range(x);  // $ range=<=400
        int sum = x + y; // $ overflow=+-
      } else {
        if (y > 300) {
          range(x); // $ range=>=302 range=<=400 range="<=InitializeParameter: y+1" MISSING: range===y+1
          range(y); // $ range=>=301 range=<=399 range="==InitializeParameter: x | Store: x-1"
          int sum = x + y;
        }
      }

      if (x > 500) {
        range(x); // $ range=<=400 range=>=501
        return x;
      }
    }

    return 0;
  }

  int f2(int x, int y, int z) {
    if (x < 500) {
      if (x > 400) {
        range(x);  // $ range=>=401 range=<=499
        return x;
      }

      if (y == x - 1 && y > 300 && y + 2 == z && z == 350) { // $ overflow=+ overflow=-
        range(x);  // $ range===349 range="==InitializeParameter: y+1" range="==InitializeParameter: z-1"
        range(y);  // $ range===348 range=">=InitializeParameter: x | Store: x-1" range="==InitializeParameter: z-2" MISSING: range===x-1 
        range(z);  // $ range===350 range="<=InitializeParameter: y+2" MISSING: range===x+1 range===y+2
        return x + y + z;
      }
    }

    return 0;
  }

  void* f3_get(int n);

  void f3() {
    int n = 0;
    while (f3_get(n)) n+=2;

    for (int i = 0; i < n; i += 2) {
      range(i); // $ range=>=0 SPURIOUS: range="<=Phi: call to f3_get-1" range="<=Phi: call to f3_get-2"
    }
  }

int f4(int x) {
  for (int i = 0; i <= 100; i++) {
    range(i); // $ range=<=100 range=>=0
    if(i == 100) {
      range(i); // $ range===100
    } else {
      range(i); // $ range=<=99 range=>=0
    }
  }
}
