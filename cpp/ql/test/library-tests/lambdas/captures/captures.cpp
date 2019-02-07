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

  static void c(int x) {
    [x] {
      c(0); // `x` is unused, but still captured.
    };
  }
};
