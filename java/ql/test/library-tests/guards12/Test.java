class Test {
  void foo(String s) {
    int x = switch(s) {
      case "a", "b" -> 1;
      case "c" -> 2;
      case "d" -> 2;
      default -> 3;
    };
    switch (s) {
      case "a", "b" -> { }
      case "c" -> { }
      case "d" -> { }
      default -> { }
    }
    switch (s) {
      case String s2 when s.length() == 4 -> { }
      case "e" -> { }
      default -> { }
    }
  }
}
