import java.util.function.Function;

class A {
  String source() { return ""; }

  void sink(String s) { }

  String propagateState(String s, String state) {
    return "";
  }

  void foo() {
    Function<String, String> lambda = Math.random() > 0.5
      ? x -> propagateState(x, "A")
      : x -> propagateState(x, "B");

    String step0 = source();
    String step1 = lambda.apply(step0);
    String step2 = lambda.apply(step1);

    sink(step2);
  }

  void bar() {
    Function<String, String> lambda =
      (x -> Math.random() > 0.5 ? propagateState(x, "A") : propagateState(x, "B"));

    String step0 = source();
    String step1 = lambda.apply(step0);
    String step2 = lambda.apply(step1);

    sink(step2);
  }
}
