void foo();
void bar(void);
void baz(int);

void test() {
  foo(); // GOOD
  foo(1); // BAD
  bar(); // GOOD
  baz(1); // GOOD
  
  undeclared(1); // GOOD
  
  not_yet_declared1(1); // BAD
  not_yet_declared2(1); // GOOD
}

void not_yet_declared1();
void not_yet_declared2(int);