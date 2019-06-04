class Test {
  void foo(String s) {
    int x = switch(s) {
      case "a", "b" -> 1;
      case "c" -> 2;
      default -> 3;
    };
  }
}
