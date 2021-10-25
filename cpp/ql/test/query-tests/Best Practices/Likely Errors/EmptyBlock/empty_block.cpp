// semmle-extractor-options: -std=c++17

// GOOD:
void f() {
}

int f(int x) {
  // BAD:
  if (x) {}

  // BAD:
  if (x) {
  }

  if (x) {
    // GOOD (has comment)
  }

  // BAD (comment comes after):
  if (x) {
  }
  // comment

  // GOOD (exception for loops with block on same line):
  while (--x == 27) {}

  // GOOD:
  while (--x == 2) {
  }

  // GOOD:
  do {
  } while (--x == 2);

  // GOOD:
  if (x) {
#ifdef NOT_DEFINED
    return 7;
#endif
  }

#define EMPTY
  // GOOD:
  if (x) {
    EMPTY
  }

  // GOOD (no block)
  if (1) ;

  // GOOD (no block)
  for (;;) ;

  // GOOD (has comment): [FALSE POSITIVE]
  if (x) {} // comment

  // GOOD (has comment): [FALSE POSITIVE]
  if (x) {}  // comment

  // GOOD
  if (x) {
    if constexpr(1) {
      f();
    }
  }

  // GOOD
  if (x) {
    if constexpr(0) {
      f();
    }
  }

  // GOOD
  if (x) {
    if constexpr(1) {
      f();
    } else {
      f();
    }
  }

  return 1;
}
