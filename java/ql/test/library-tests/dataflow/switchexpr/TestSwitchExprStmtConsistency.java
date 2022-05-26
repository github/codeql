public class TestSwitchExprStmtConsistency {

  static int f() { return 0; }

  public static void test(int x) {

    // Test that getRuleExpression() and getRuleStatement() behave alike for switch expressions and statements using arrow rules.

    switch(x) {
      case 1 -> f();
      case 2 -> f();
      default -> f();
    }

    int result = switch(x) {
      case 1 -> f();
      case 2 -> f();
      default -> f();
    };

  }

}
