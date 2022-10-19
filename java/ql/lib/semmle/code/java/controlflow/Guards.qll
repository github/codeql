/**
 * Provides classes and predicates for reasoning about guards and the control
 * flow elements controlled by those guards.
 */

import java
private import semmle.code.java.controlflow.Dominance
private import semmle.code.java.controlflow.internal.GuardsLogic
private import semmle.code.java.controlflow.internal.Preconditions

/**
 * A basic block that terminates in a condition, splitting the subsequent control flow.
 */
class ConditionBlock extends BasicBlock {
  ConditionBlock() { this.getLastNode() instanceof ConditionNode }

  /** Gets the last node of this basic block. */
  ConditionNode getConditionNode() { result = this.getLastNode() }

  /** Gets the condition of the last node of this basic block. */
  Expr getCondition() { result = this.getConditionNode().getCondition() }

  /** Gets a `true`- or `false`-successor of the last node of this basic block. */
  BasicBlock getTestSuccessor(boolean testIsTrue) {
    result = this.getConditionNode().getABranchSuccessor(testIsTrue)
  }

  /*
   * For this block to control the block `controlled` with `testIsTrue` the following must be true:
   * Execution must have passed through the test i.e. `this` must strictly dominate `controlled`.
   * Execution must have passed through the `testIsTrue` edge leaving `this`.
   *
   * Although "passed through the true edge" implies that `this.getATrueSuccessor()` dominates `controlled`,
   * the reverse is not true, as flow may have passed through another edge to get to `this.getATrueSuccessor()`
   * so we need to assert that `this.getATrueSuccessor()` dominates `controlled` *and* that
   * all predecessors of `this.getATrueSuccessor()` are either `this` or dominated by `this.getATrueSuccessor()`.
   *
   * For example, in the following java snippet:
   * ```
   * if (x)
   *   controlled;
   * false_successor;
   * uncontrolled;
   * ```
   * `false_successor` dominates `uncontrolled`, but not all of its predecessors are `this` (`if (x)`)
   *  or dominated by itself. Whereas in the following code:
   * ```
   * if (x)
   *   while (controlled)
   *     also_controlled;
   * false_successor;
   * uncontrolled;
   * ```
   * the block `while controlled` is controlled because all of its predecessors are `this` (`if (x)`)
   * or (in the case of `also_controlled`) dominated by itself.
   *
   * The additional constraint on the predecessors of the test successor implies
   * that `this` strictly dominates `controlled` so that isn't necessary to check
   * directly.
   */

  /**
   * Holds if `controlled` is a basic block controlled by this condition, that
   * is, a basic blocks for which the condition is `testIsTrue`.
   */
  predicate controls(BasicBlock controlled, boolean testIsTrue) {
    exists(BasicBlock succ |
      succ = this.getTestSuccessor(testIsTrue) and
      dominatingEdge(this, succ) and
      succ.bbDominates(controlled)
    )
  }
}

/**
 * A condition that can be evaluated to either true or false. This can either
 * be an `Expr` of boolean type that isn't a boolean literal, or a case of a
 * switch statement, or a method access that acts as a precondition check.
 *
 * Evaluating a switch case to true corresponds to taking that switch case, and
 * evaluating it to false corresponds to taking some other branch.
 */
class Guard extends ExprParent {
  Guard() {
    this.(Expr).getType() instanceof BooleanType and not this instanceof BooleanLiteral
    or
    this instanceof SwitchCase
    or
    conditionCheckArgument(this, _, _)
  }

  /** Gets the immediately enclosing callable whose body contains this guard. */
  Callable getEnclosingCallable() {
    result = this.(Expr).getEnclosingCallable() or
    result = this.(SwitchCase).getEnclosingCallable()
  }

  /** Gets the statement containing this guard. */
  Stmt getEnclosingStmt() {
    result = this.(Expr).getEnclosingStmt() or
    result = this.(SwitchCase).getSwitch() or
    result = this.(SwitchCase).getSwitchExpr().getEnclosingStmt()
  }

  /**
   * Gets the basic block containing this guard or the basic block containing
   * the switch expression if the guard is a switch case.
   */
  BasicBlock getBasicBlock() {
    result = this.(Expr).getBasicBlock() or
    result = this.(SwitchCase).getSwitch().getExpr().getBasicBlock() or
    result = this.(SwitchCase).getSwitchExpr().getExpr().getBasicBlock()
  }

  /**
   * Holds if this guard is an equality test between `e1` and `e2`. The test
   * can be either `==`, `!=`, `.equals`, or a switch case. If the test is
   * negated, that is `!=`, then `polarity` is false, otherwise `polarity` is
   * true.
   */
  predicate isEquality(Expr e1, Expr e2, boolean polarity) {
    exists(Expr exp1, Expr exp2 | equalityGuard(this, exp1, exp2, polarity) |
      e1 = exp1 and e2 = exp2
      or
      e2 = exp1 and e1 = exp2
    )
  }

  /**
   * Holds if the evaluation of this guard to `branch` corresponds to the edge
   * from `bb1` to `bb2`.
   */
  predicate hasBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch) {
    exists(ConditionBlock cb |
      cb = bb1 and
      cb.getCondition() = this and
      bb2 = cb.getTestSuccessor(branch)
    )
    or
    exists(SwitchCase sc, ControlFlowNode pred |
      sc = this and
      branch = true and
      bb2.getFirstNode() = sc.getControlFlowNode() and
      pred = sc.getControlFlowNode().getAPredecessor() and
      pred.(Expr).getParent*() = sc.getSelectorExpr() and
      bb1 = pred.getBasicBlock()
    )
    or
    preconditionBranchEdge(this, bb1, bb2, branch)
  }

  /**
   * Holds if this guard evaluating to `branch` directly controls the block
   * `controlled`. That is, the `true`- or `false`-successor of this guard (as
   * given by `branch`) dominates `controlled`.
   */
  predicate directlyControls(BasicBlock controlled, boolean branch) {
    exists(ConditionBlock cb |
      cb.getCondition() = this and
      cb.controls(controlled, branch)
    )
    or
    switchCaseControls(this, controlled) and branch = true
    or
    preconditionControls(this, controlled, branch)
  }

  /**
   * Holds if this guard evaluating to `branch` directly or indirectly controls
   * the block `controlled`. That is, the evaluation of `controlled` is
   * dominated by this guard evaluating to `branch`.
   */
  predicate controls(BasicBlock controlled, boolean branch) {
    guardControls_v3(this, controlled, branch)
  }
}

private predicate switchCaseControls(SwitchCase sc, BasicBlock bb) {
  exists(BasicBlock caseblock, Expr selector |
    selector = sc.getSelectorExpr() and
    caseblock.getFirstNode() = sc.getControlFlowNode() and
    caseblock.bbDominates(bb) and
    forall(ControlFlowNode pred | pred = sc.getControlFlowNode().getAPredecessor() |
      pred.(Expr).getParent*() = selector
    )
  )
}

private predicate preconditionBranchEdge(
  MethodAccess ma, BasicBlock bb1, BasicBlock bb2, boolean branch
) {
  conditionCheckArgument(ma, _, branch) and
  bb1.getLastNode() = ma.getControlFlowNode() and
  bb2 = bb1.getLastNode().getANormalSuccessor()
}

private predicate preconditionControls(MethodAccess ma, BasicBlock controlled, boolean branch) {
  exists(BasicBlock check, BasicBlock succ |
    preconditionBranchEdge(ma, check, succ, branch) and
    dominatingEdge(check, succ) and
    succ.bbDominates(controlled)
  )
}

/**
 * INTERNAL: Use `Guards.controls` instead.
 *
 * Holds if `guard.controls(controlled, branch)`, except this only relies on
 * BaseSSA-based reasoning.
 */
predicate guardControls_v1(Guard guard, BasicBlock controlled, boolean branch) {
  guard.directlyControls(controlled, branch)
  or
  exists(Guard g, boolean b |
    guardControls_v1(g, controlled, b) and
    implies_v1(g, b, guard, branch)
  )
}

/**
 * INTERNAL: Use `Guards.controls` instead.
 *
 * Holds if `guard.controls(controlled, branch)`, except this doesn't rely on
 * RangeAnalysis.
 */
predicate guardControls_v2(Guard guard, BasicBlock controlled, boolean branch) {
  guard.directlyControls(controlled, branch)
  or
  exists(Guard g, boolean b |
    guardControls_v2(g, controlled, b) and
    implies_v2(g, b, guard, branch)
  )
}

pragma[nomagic]
private predicate guardControls_v3(Guard guard, BasicBlock controlled, boolean branch) {
  guard.directlyControls(controlled, branch)
  or
  exists(Guard g, boolean b |
    guardControls_v3(g, controlled, b) and
    implies_v3(g, b, guard, branch)
  )
}

private predicate equalityGuard(Guard g, Expr e1, Expr e2, boolean polarity) {
  exists(EqualityTest eqtest |
    eqtest = g and
    polarity = eqtest.polarity() and
    eqtest.hasOperands(e1, e2)
  )
  or
  exists(MethodAccess ma |
    ma = g and
    ma.getMethod() instanceof EqualsMethod and
    polarity = true and
    ma.getAnArgument() = e1 and
    ma.getQualifier() = e2
  )
  or
  exists(MethodAccess ma, Method equals |
    ma = g and
    ma.getMethod() = equals and
    polarity = true and
    equals.hasName("equals") and
    equals.getNumberOfParameters() = 2 and
    equals.getDeclaringType().hasQualifiedName("java.util", "Objects") and
    ma.getArgument(0) = e1 and
    ma.getArgument(1) = e2
  )
  or
  exists(ConstCase cc |
    cc = g and
    polarity = true and
    cc.getSelectorExpr() = e1 and
    cc.getValue() = e2 and
    strictcount(cc.getValue(_)) = 1
  )
}
