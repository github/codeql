/**
 * @name Guarded Free
 * @description NULL-condition guards before function calls to the memory-deallocation
 *              function free(3) are unnecessary, because passing NULL to free(3) is a no-op.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/guarded-free
 * @tags maintainability
 *       readability
 *       experimental
 */

import cpp

class FreeCall extends FunctionCall {
  FreeCall() { this.getTarget().hasName("free") }
}

from IfStmt stmt, FreeCall fc, Variable v
where
  stmt.getThen() = fc.getEnclosingStmt() and
  (
    stmt.getCondition() = v.getAnAccess() and
    fc.getArgument(0) = v.getAnAccess()
    or
    exists(PointerDereferenceExpr cond, PointerDereferenceExpr arg |
      fc.getArgument(0) = arg and
      stmt.getCondition() = cond and
      cond.getOperand+() = v.getAnAccess() and
      arg.getOperand+() = v.getAnAccess()
    )
    or
    exists(ArrayExpr cond, ArrayExpr arg |
      fc.getArgument(0) = arg and
      stmt.getCondition() = cond and
      cond.getArrayBase+() = v.getAnAccess() and
      arg.getArrayBase+() = v.getAnAccess()
    )
    or
    exists(NEExpr eq |
      fc.getArgument(0) = v.getAnAccess() and
      stmt.getCondition() = eq and
      eq.getAnOperand() = v.getAnAccess() and
      eq.getAnOperand().getValue() = "0"
    )
  )
select stmt, "unnecessary NULL check before call to $@", fc, "free"
