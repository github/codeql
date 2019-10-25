#include "statements.h"

void simple() {
  NonTrivial nt;
}

void simple2() {
  NonTrivial one;
  NonTrivial two;
}

void early_return(int x) {
  NonTrivial before;
  if(x) {
    NonTrivial inner;
    return;
  }
  NonTrivial after;
}

void early_throw(int x) {
  NonTrivial before;
  if(x) {
    NonTrivial inner;
    throw;
  }
  NonTrivial after;
}

void for_loop_scope(int x) {
  NonTrivial outer_scope;
  for(NonTrivial for_scope; x < 10; ++x)
  {
    NonTrivial inner_scope;
  }
}

void never_destructs() {
  NonTrivial nt;
  loop: goto loop;
}

void gotos(int x) {
  NonTrivial nt1;
  if(x)
    goto one; // this goto jumps into a block
  {
    static int y = ++x;
one:
    NonTrivial nt2;
    if(y)
      goto two; // this goto jumps out of a block
    NonTrivial nt3;
  }
two:
  --x;
}
