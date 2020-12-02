// This file is present to test whether name-qualifying an enum constant leads to a database inconsistency.
// As such, there is no QL part of the test.

struct S { enum E { A }; };

static int f() {
  switch(0) { case S::A: break; }
}
