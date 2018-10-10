/**
 * Provides classes for working with defensive programming patterns.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * A test in a defensive programming pattern.
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

  /**
   * Gets the inner expression of `e`, with any surrounding parentheses and boolean nots removed.
   * `polarity` is true iff the inner expression is nested in an even number of negations.
   */
  private Expr stripNotsAndParens(Expr e, boolean polarity) {
    exists (Expr inner |
      inner = e.stripParens() |
      if inner instanceof LogNotExpr then
        (result = stripNotsAndParens(inner.(LogNotExpr).getOperand(), polarity.booleanNot()))
      else
        (result = inner and polarity = true)
    )
  }

  /**
   * An equality test for `null` and `undefined`.
   */
  private abstract class UndefinedNullTest extends EqualityTest {
    /** Gets the unique Boolean value that this test evaluates to, if any. */
    abstract boolean getTheTestResult();

    /**
     * Gets the expression that is tested for being `null` or `undefined`.
     */
    abstract Expr getOperand();
  }

  /**
   * A dis- or conjunction that tests if an expression is `null` or `undefined` in either branch.
   */
  private class CompositeUndefinedNullTestPart extends DefensiveExpression {

    UndefinedNullTest test;

    boolean polarity;

    CompositeUndefinedNullTestPart(){
      exists (BinaryExpr composite, Variable v, Expr op, Expr opOther, UndefinedNullTest testOther |
        composite instanceof LogAndExpr or
        composite instanceof LogOrExpr |
        composite.hasOperands(op, opOther) and
        this = op.flow() and
        test = stripNotsAndParens(op, polarity) and
        testOther = stripNotsAndParens(opOther, _) and
        test.getOperand().(VarRef).getVariable() = v and
        testOther.getOperand().(VarRef).getVariable() = v
      )
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * A test for `undefined` or `null` in an if-statement.
   */
  private class SanityCheckingUndefinedNullGuard extends DefensiveExpression {

    UndefinedNullTest test;

    boolean polarity;

    SanityCheckingUndefinedNullGuard() {
      exists (IfStmt c |
        this = c.getCondition().flow() and
        test = stripNotsAndParens(c.getCondition(), polarity) and
        test.getOperand() instanceof VarRef
      )
    }

    override boolean getTheTestResult() {
      polarity = true and result = test.getTheTestResult()
      or
      polarity = false and result = test.getTheTestResult().booleanNot()
    }

  }

  /**
   * Holds if `t` is `null` or `undefined`.
   */
  private predicate isNullOrUndefined(InferredType t) {
    t = TTNull() or
    t = TTUndefined()
  }

  /**
   * Holds if `t` is not `null` or `undefined`.
   */
  private predicate isNotNullOrUndefined(InferredType t) {
    not isNullOrUndefined(t)
  }

  /**
   * A value comparison for `null` and `undefined`.
   */
  private class NullUndefinedComparison extends UndefinedNullTest {

    Expr operand;

    InferredType op2type;

    NullUndefinedComparison() {
      exists (Expr op2 |
        hasOperands(operand, op2) |
        op2type = TTNull() and SyntacticConstants::isNull(op2)
        or
        op2type = TTUndefined() and SyntacticConstants::isUndefined(op2)
      )
    }

    override boolean getTheTestResult() {
      result = getPolarity() and
      (
        if this instanceof StrictEqualityTest then
          operand.analyze().getTheType() = op2type
        else
          not isNotNullOrUndefined(operand.analyze().getAType())
      )
      or
      result = getPolarity().booleanNot() and
      (
        if this instanceof StrictEqualityTest then
          not operand.analyze().getAType() = op2type
        else
          not isNullOrUndefined(operand.analyze().getAType())
      )
    }

    override Expr getOperand() {
      result = operand
    }
  }

  /**
   * An expression that throws an exception if one of its subexpressions evaluates to `null` or `undefined`.
   */
  private class UndefinedNullCrashUse extends Expr {

    Expr target;

    UndefinedNullCrashUse() {
      this.(InvokeExpr).getCallee().stripParens() = target
      or
      this.(PropAccess).getBase().stripParens() = target
      or
      this.(MethodCallExpr).getReceiver().stripParens() = target
    }

    /**
     * Gets the subexpression that will cause an exception to be thrown if it is `null` or `undefined`.
     */
    Expr getVulnerableSubexpression() {
      result = target
    }

  }

  /**
   * An expression that throws an exception if one of its subexpressions is not a `function`.
   */
  private class NonFunctionCallCrashUse extends Expr {

    Expr target;

    NonFunctionCallCrashUse() {
      this.(InvokeExpr).getCallee().stripParens() = target
    }

    /**
     * Gets the subexpression that will cause an exception to be thrown if it is not a `function`.
     */
    Expr getVulnerableSubexpression() {
      result = target
    }

  }

  /**
   * Gets the first expression that is guarded by `guard`.
   */
  private Expr getAGuardedExpr(Expr guard) {
    exists(BinaryExpr op |
      op.getLeftOperand() = guard and
      (op instanceof LogAndExpr or op instanceof LogOrExpr) and
      op.getRightOperand() = result
    )
    or
    exists(IfStmt c |
      c.getCondition() = guard |
      result = c.getAControlledStmt().getChildExpr(0) or
      result = c.getAControlledStmt().(BlockStmt).getStmt(0).getChildExpr(0)
    )
    or
    exists (ConditionalExpr c |
      c.getCondition() = guard |
      result = c.getABranch()
    )
  }

}