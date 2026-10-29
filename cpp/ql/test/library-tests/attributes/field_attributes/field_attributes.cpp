struct S1 {
  [[deprecated]] int a;
  int b;
};

struct S2 {
  int x;
  [[deprecated, gnu::unused]] int b;
};
