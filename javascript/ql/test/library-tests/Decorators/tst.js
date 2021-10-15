@A @B class C {
  @testable(true) m() { }
}

var o = {
  @Foo
  get bar() { return 42 },
  set bar(v) { }
};
