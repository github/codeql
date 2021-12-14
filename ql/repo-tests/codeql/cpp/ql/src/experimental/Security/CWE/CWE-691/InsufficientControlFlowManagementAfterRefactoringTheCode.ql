/**
 * @name Errors After Refactoring
 * @description --In some situations, after code refactoring, parts of the old constructs may remain.
 *              --They are correctly accepted by the compiler, but can critically affect program execution.
 *              --For example, if you switch from `do {...} while ();` to `while () {...}` with errors, you run the risk of running out of resources.
 *              --These code snippets look suspicious and require the developer's attention.
 * @kind problem
 * @id cpp/errors-after-refactoring
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-691
 */

import cpp
import semmle.code.cpp.valuenumbering.HashCons
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * Using `while` directly after the body of another` while`.
 */
class UsingWhileAfterWhile extends WhileStmt {
  /**
   * Using a loop call after another loop has finished running can result in an eternal loop.
   * For example, perhaps as a result of refactoring, the `do ... while ()` loop was incorrectly corrected.
   * Even in the case of deliberate use of such an expression, it is better to correct it.
   */
  UsingWhileAfterWhile() {
    exists(WhileStmt wh1 |
      wh1.getStmt().getAChild*().(BreakStmt).(ControlFlowNode).getASuccessor().getASuccessor() =
        this and
      hashCons(wh1.getCondition()) = hashCons(this.getCondition()) and
      this.getStmt() instanceof EmptyStmt
    )
    or
    exists(ForStmt fr1 |
      fr1.getStmt().getAChild*().(BreakStmt).(ControlFlowNode).getASuccessor().getASuccessor() =
        this and
      hashCons(fr1.getCondition()) = hashCons(this.getCondition()) and
      this.getStmt() instanceof EmptyStmt
    )
  }
}

/**
 * Using arithmetic in a condition.
 */
class UsingArithmeticInComparison extends BinaryArithmeticOperation {
  /**
   * Using arithmetic operations in a comparison operation can be dangerous.
   * For example, part of the comparison may have been lost as a result of refactoring.
   * Even if you deliberately use such an expression, it is better to add an explicit comparison.
   */
  UsingArithmeticInComparison() {
    this.getParent*() instanceof IfStmt and
    not this.getAChild*().isConstant() and
    not this.getParent*() instanceof Call and
    not this.getParent*() instanceof AssignExpr and
    not this.getParent*() instanceof ArrayExpr and
    not this.getParent*() instanceof RemExpr and
    not this.getParent*() instanceof AssignBitwiseOperation and
    not this.getParent*() instanceof AssignArithmeticOperation and
    not this.getParent*() instanceof EqualityOperation and
    not this.getParent*() instanceof RelationalOperation
  }

  /** Holds when the expression is inside the loop body. */
  predicate insideTheLoop() { exists(Loop lp | lp.getStmt().getAChild*() = this.getParent*()) }

  /** Holds when the expression is used in binary operations. */
  predicate workingWithValue() {
    this.getParent*() instanceof BinaryBitwiseOperation or
    this.getParent*() instanceof NotExpr
  }

  /** Holds when the expression contains a pointer. */
  predicate workingWithPointer() {
    this.getAChild*().getFullyConverted().getType() instanceof DerivedType
  }

  /** Holds when a null comparison expression exists. */
  predicate compareWithZero() {
    exists(Expr exp |
      exp instanceof ComparisonOperation and
      (
        globalValueNumber(exp.getAChild*()) = globalValueNumber(this) or
        hashCons(exp.getAChild*()) = hashCons(this)
      ) and
      (
        exp.(ComparisonOperation).getLeftOperand().getValue() = "0" or
        exp.(ComparisonOperation).getRightOperand().getValue() = "0"
      )
    )
  }

  /** Holds when a comparison expression exists. */
  predicate compareWithOutZero() {
    exists(Expr exp |
      exp instanceof ComparisonOperation and
      (
        globalValueNumber(exp.getAChild*()) = globalValueNumber(this) or
        hashCons(exp.getAChild*()) = hashCons(this)
      )
    )
  }
}

from Expr exp
where
  exp instanceof UsingArithmeticInComparison and
  not exp.(UsingArithmeticInComparison).workingWithValue() and
  not exp.(UsingArithmeticInComparison).workingWithPointer() and
  not exp.(UsingArithmeticInComparison).insideTheLoop() and
  not exp.(UsingArithmeticInComparison).compareWithZero() and
  exp.(UsingArithmeticInComparison).compareWithOutZero()
  or
  exists(WhileStmt wst | wst instanceof UsingWhileAfterWhile and exp = wst.getCondition())
select exp, "this expression needs your attention"
