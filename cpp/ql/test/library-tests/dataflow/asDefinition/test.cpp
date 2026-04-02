struct S {
  int x;
};

void use(int);

void test() {
  int y = 43; // $ asDefinition=43
  use(y);
  y = 44; // $ asDefinition="... = ..."
  use(y);

  int x = 43; // $ asDefinition=43
  x = 44; // $ asDefinition="... = ..."

  S s;
  s.x = 42; // $ asDefinition="... = ..."
}