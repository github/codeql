/**
 * @name Nested loops with same variable
 * @description The behavior of nested loops that both have the same iteration variable can be difficult to understand, as the inner loop will affect the
 *              iteration of the outer loop. Most of the time this is an unintentional typo and a bug; in other cases it is merely very bad practice.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/nested-loops-with-same-variable
 * @tags maintainability
 *       correctness
 *       logic
 */

import csharp
import semmle.code.csharp.commons.ComparisonTest
import semmle.code.csharp.commons.StructuralComparison as SC

/** A structural comparison configuration for comparing the conditions of nested `for` loops. */
class NestedForConditions extends SC::StructuralComparisonConfiguration {
  NestedForConditions() { this = "Compare nested for conditions" }

  override predicate candidate(ControlFlowElement e1, ControlFlowElement e2) {
    exists(NestedForLoopSameVariable nested |
      e1 = nested.getInnerForStmt().getCondition() and
      e2 = nested.getOuterForStmt().getCondition()
    )
  }
}

/** A nested `for` statement that shares the same iteration variable as an outer `for` statement. */
class NestedForLoopSameVariable extends ForStmt {
  ForStmt outer;
  Variable iteration;
  MutatorOperation innerUpdate;
  MutatorOperation outerUpdate;

  NestedForLoopSameVariable() {
    outer = this.getParent+() and
    innerUpdate = this.getAnUpdate() and
    outerUpdate = outer.getAnUpdate() and
    innerUpdate.getOperand() = iteration.getAnAccess() and
    outerUpdate.getOperand() = iteration.getAnAccess()
  }

  /** Gets this inner `for` statement. */
  ForStmt getInnerForStmt() { result = this }

  /** Gets the outer, enclosing `for` statement. */
  ForStmt getOuterForStmt() { result = outer }

  private ComparisonTest getAComparisonTest(VariableAccess access) {
    access = iteration.getAnAccess() and
    result.getAnArgument() = access
  }

  private predicate haveSameCondition() {
    exists(NestedForConditions config |
      config.same(getInnerForStmt().getCondition(), getOuterForStmt().getCondition())
    )
  }

  private predicate haveSameUpdate() {
    innerUpdate instanceof IncrementOperation and outerUpdate instanceof IncrementOperation
    or
    innerUpdate instanceof DecrementOperation and outerUpdate instanceof DecrementOperation
  }

  /** Holds if the logic is deemed to be correct in limited circumstances. */
  predicate isSafe() {
    haveSameUpdate() and haveSameCondition() and not exists(getAnUnguardedAccess())
  }

  /** Gets the result element. */
  Expr getElement() { result = this.getCondition() }

  /** Gets the result message. */
  string getMessage() {
    exists(string name, Location location, int startLine, string lineStr |
      name = iteration.getName() and
      location = outer.getLocation() and
      location.hasLocationInfo(_, startLine, _, _, _) and
      lineStr = startLine.toString() and
      result =
        "Nested for statement uses loop variable " + name + " of enclosing for statement (on line " +
          lineStr + ")."
    )
  }

  /** Finds elements inside the outer loop that are no longer guarded by the loop invariant. */
  private ControlFlow::Node getAnUnguardedNode() {
    result.getElement().getParent+() = getOuterForStmt().getBody() and
    (
      result =
        this.getCondition().(ControlFlowElement).getAControlFlowExitNode().getAFalseSuccessor()
      or
      exists(ControlFlow::Node mid | mid = getAnUnguardedNode() |
        mid.getASuccessor() = result and
        not exists(getAComparisonTest(result.getElement()))
      )
    )
  }

  private VariableAccess getAnUnguardedAccess() {
    result = getAnUnguardedNode().getElement() and
    result.getTarget() = iteration
  }
}

from NestedForLoopSameVariable inner
where not inner.isSafe()
select inner.getElement(), inner.getMessage()
