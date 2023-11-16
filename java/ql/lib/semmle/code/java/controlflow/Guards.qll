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
  ExprParent getCondition() { result = this.getConditionNode().getCondition() }

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
   * Gets the basic block containing this guard or the basic block that tests the
   * applicability of this switch case -- for a pattern case this is the case statement
   * itself; for a non-pattern case this is the most recent pattern case or the top of
   * the switch block if there is none.
   */
  BasicBlock getBasicBlock() {
    // Not a switch case
    result = this.(Expr).getBasicBlock()
    or
    // Return the closest pattern case statement before this one, including this one.
    result =
      max(int i, PatternCase c |
        c = this.(SwitchCase).getSiblingCase(i) and i <= this.(SwitchCase).getCaseIndex()
      |
        c order by i
      ).getBasicBlock()
    or
    // Not a pattern case and no preceding pattern case -- return the top of the switch block.
    not exists(PatternCase c, int i |
      c = this.(SwitchCase).getSiblingCase(i) and i <= this.(SwitchCase).getCaseIndex()
    ) and
    result = this.(SwitchCase).getSelectorExpr().getBasicBlock()
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
    exists(SwitchCase sc |
      sc = this and
      // Pattern cases are handled as ConditionBlocks above.
      not sc instanceof PatternCase and
      branch = true and
      bb2.getFirstNode() = sc.getControlFlowNode() and
      bb1 = sc.getControlFlowNode().getAPredecessor().getBasicBlock() and
      // This is either the top of the switch block, or a preceding pattern case
      // if one exists.
      this.getBasicBlock() = bb1
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

/**
 * A `Guard` that tests an expression's type -- that is, an `instanceof T` or a
 * `case T varname` pattern case.
 */
class TypeTestGuard extends Guard {
  Expr testedExpr;
  Type testedType;

  TypeTestGuard() {
    exists(InstanceOfExpr ioe | this = ioe |
      testedExpr = ioe.getExpr() and
      testedType = ioe.getCheckedType()
    )
    or
    exists(PatternCase pc | this = pc |
      pc.getSelectorExpr() = testedExpr and
      testedType = pc.getPattern().getType()
    )
  }

  /**
   * Gets the record pattern this type test binds to, if any.
   */
  PatternExpr getPattern() {
    result = this.(InstanceOfExpr).getPattern()
    or
    result = this.(PatternCase).getPattern()
  }

  /**
   * Holds if this guard tests whether `e` has type `t`.
   *
   * Note that record patterns that make at least one tighter restriction than the record's definition
   * (e.g. matching `record R(Object)` with `case R(String)`) means this only guarantees the tested type
   * on the true branch (i.e., entering such a case guarantees `testedExpr` is a `testedType`, but failing
   * the type test could mean a nested record or binding pattern didn't match but `testedExpr` is still
   * of type `testedType`.)
   */
  predicate appliesTypeTest(Expr e, Type t, boolean testedBranch) {
    e = testedExpr and
    t = testedType and
    (
      testedBranch = true
      or
      testedBranch = false and
      (
        this.getPattern().asRecordPattern().isUnrestricted()
        or
        not this.getPattern() instanceof RecordPatternExpr
      )
    )
  }
}

private predicate switchCaseControls(SwitchCase sc, BasicBlock bb) {
  exists(BasicBlock caseblock |
    caseblock.getFirstNode() = sc.getControlFlowNode() and
    caseblock.bbDominates(bb) and
    // Check we can't fall through from a previous block:
    forall(ControlFlowNode pred | pred = sc.getControlFlowNode().getAPredecessor() |
      // Branch straight from the switch selector:
      pred.(Expr).getParent*() = sc.getSelectorExpr()
      or
      // Branch from a predecessor pattern case (note pattern cases cannot ever fall through)
      pred = sc.getSiblingCase(_).(PatternCase)
      or
      // Branch from a predecessor pattern case's guard test, which also can't be a fallthrough edge
      pred.(Expr).getParent*() = sc.getSiblingCase(_).(PatternCase).getGuard()
    )
  )
}

private predicate preconditionBranchEdge(
  MethodCall ma, BasicBlock bb1, BasicBlock bb2, boolean branch
) {
  conditionCheckArgument(ma, _, branch) and
  bb1.getLastNode() = ma.getControlFlowNode() and
  bb2 = bb1.getLastNode().getANormalSuccessor()
}

private predicate preconditionControls(MethodCall ma, BasicBlock controlled, boolean branch) {
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
  exists(MethodCall ma |
    ma = g and
    ma.getMethod() instanceof EqualsMethod and
    polarity = true and
    ma.getAnArgument() = e1 and
    ma.getQualifier() = e2
  )
  or
  exists(MethodCall ma, Method equals |
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
