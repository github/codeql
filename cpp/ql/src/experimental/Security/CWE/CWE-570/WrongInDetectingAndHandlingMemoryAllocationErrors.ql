/**
 * @name Detect And Handle Memory Allocation Errors
 * @description --::operator new(std::size_t) throws an exception on error, and ::operator new(std::size_t, const std::nothrow_t &) returns zero on error.
 *              --the programmer can get confused when check the error that occurs when allocating memory incorrectly.
 * @kind problem
 * @id cpp/detect-and-handle-memory-allocation-errors
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-570
 */

import cpp

/**
 * Lookup if condition compare with 0
 */
class IfCompareWithZero extends IfStmt {
  IfCompareWithZero() {
    this.getCondition().(EQExpr).getAChild().getValue() = "0"
    or
    this.getCondition().(NEExpr).getAChild().getValue() = "0" and
    this.hasElse()
    or
    this.getCondition().(NEExpr).getAChild().getValue() = "0" and
    this.getThen().getAChild*() instanceof ReturnStmt
  }
}

/**
 * lookup for calls to `operator new`, with incorrect error handling.
 */
class WrongCheckErrorOperatorNew extends FunctionCall {
  Expr exp;

  WrongCheckErrorOperatorNew() {
    this = exp.(NewOrNewArrayExpr).getAChild().(FunctionCall) and
    (
      this.getTarget().hasGlobalOrStdName("operator new")
      or
      this.getTarget().hasGlobalOrStdName("operator new[]")
    )
  }

  /**
   * Holds if handler `try ... catch` exists.
   */
  predicate isExistsTryCatchBlock() {
    exists(TryStmt ts | this.getEnclosingStmt() = ts.getStmt().getAChild*())
  }

  /**
   * Holds if results call `operator new` check in `operator if`.
   */
  predicate isExistsIfCondition() {
    exists(IfCompareWithZero ifc, AssignExpr aex, Initializer it |
      // call `operator new` directly from the condition of `operator if`.
      this = ifc.getCondition().getAChild*()
      or
      // check results call `operator new` with variable appropriation
      postDominates(ifc, this) and
      aex.getAChild() = exp and
      ifc.getCondition().getAChild().(VariableAccess).getTarget() =
        aex.getLValue().(VariableAccess).getTarget()
      or
      // check results call `operator new` with declaration variable
      postDominates(ifc, this) and
      exp = it.getExpr() and
      it.getDeclaration() = ifc.getCondition().getAChild().(VariableAccess).getTarget()
    )
  }

  /**
   * Holds if `(std::nothrow)` or `(std::noexcept)` exists in call `operator new`.
   */
  predicate isExistsNothrow() { getTarget().isNoExcept() or getTarget().isNoThrow() }
}

from WrongCheckErrorOperatorNew op
where
  // use call `operator new` with `(std::nothrow)` and checking error using `try ... catch` block and not `operator if`
  op.isExistsNothrow() and not op.isExistsIfCondition() and op.isExistsTryCatchBlock()
  or
  // use call `operator new` without `(std::nothrow)` and checking error using `operator if` and not  `try ... catch` block
  not op.isExistsNothrow() and not op.isExistsTryCatchBlock() and op.isExistsIfCondition()
select op, "memory allocation error check is incorrect or missing"
