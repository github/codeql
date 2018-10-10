/**
 * Provides classes for working with defensive programming patterns.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * The test in a defensive programming pattern.
 */
abstract class DefensiveExpression extends DataFlow::ValueNode {
  /** Gets the unique Boolean value that this test evaluates to, if any. */
  abstract boolean getTheTestResult();
}

/**
 * INTERNAL: Do not use directly; use `DefensiveExpression` instead.
 */
module Internal {
  /**
   * A defensive truthiness check that may be worth keeping, even if it
   * is strictly speaking useless.
   *
   * We currently recognize three patterns:
   *
   *   - the first `x` in `x || (x = e)`
   *   - the second `x` in `x = (x || e)`
   *   - the second `x` in `var x = x || e`
   */
  class DefensiveInit extends DefensiveExpression {
    DefensiveInit() {
      exists(VarAccess va, LogOrExpr o, VarRef va2 |
        va = astNode and
        va = o.getLeftOperand().stripParens() and va2.getVariable() = va.getVariable() |
        exists(AssignExpr assgn | va2 = assgn.getTarget() |
          assgn = o.getRightOperand().stripParens() or
          o = assgn.getRhs().stripParens()
        )
        or
        exists(VariableDeclarator vd | va2 = vd.getBindingPattern() | o = vd.getInit().stripParens())
      )
    }

    override boolean getTheTestResult() {
      result = analyze().getTheBooleanValue()
    }
  }

}