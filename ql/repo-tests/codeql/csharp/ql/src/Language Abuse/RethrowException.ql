/**
 * @name Rethrowing exception variable
 * @description Throwing the exception variable will lose the original stack information.
 *              This can make errors harder to diagnose.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/rethrown-exception-variable
 * @tags maintainability
 *       language-features
 *       exceptions
 */

import csharp

CatchClause containingCatchClause(Stmt s) {
  result.getBlock() = s
  or
  exists(Stmt mid |
    result = containingCatchClause(mid) and
    mid.getAChildStmt() = s and
    not mid instanceof CatchClause
  )
}

from SpecificCatchClause cc, ThrowStmt throw
where
  throw.getExpr() = cc.getVariable().getAnAccess() and
  containingCatchClause(throw) = cc
select throw, "Rethrowing exception variable."
