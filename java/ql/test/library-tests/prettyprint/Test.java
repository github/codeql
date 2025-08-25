public class Test {

  record S(int x) { }
  record R(S s, String y) { }

  public static void test(Object o) {

    switch(o) {
      case String s:
        break;
      case R(S(int x), String y):
        break;
      default:
        break;
    }

    switch(o) {
      case String s -> { }
      case R(S(int x), String y) -> { }
      case null, default -> { }
    }

    var a = switch(o) {
      case String s:
        yield 1;
      case R(S(int x), String y):
        yield x;
      case null, default:
        yield 2;
    };

    var b = switch(o) {
      case String s -> 1;
      case R(S(int x), String y) -> x;
      default -> 2;
    };

    if (o instanceof String s) { }
    if (o instanceof R(S(int x), String y)) { }

    switch(o) {
      case R(S(var x), var y) -> { }
      case null, default -> { }
    }

    if (o instanceof R(S(var x), var y)) { }

    switch(o) {
      case String _, Integer _:
      case R(S(_), _):
      default:
        break;
    }

  }

}
