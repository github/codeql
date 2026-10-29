// This file is present to test whether name-qualifying an enum constant leads to a database inconsistency.


struct S { enum E { A }; };

static void f() {
  switch(0) { case S::A: break; }
}
