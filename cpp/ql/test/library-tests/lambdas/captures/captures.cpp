struct foo {
  void a(int x) {
    [x, this] {
      a(x + 1);
    };
  }
  
  void b(int x) {
    [=] {
      b(x + 1);
    };
  }
};
