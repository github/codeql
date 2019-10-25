
int x = int();
float y = float();
double z = double();

/* This produces a getValueText() of 0 for R() in line 9, which is debatable.  */
struct R {};
struct S {
  S() : S(R()) { }
  S(R) { }
};
S s;
