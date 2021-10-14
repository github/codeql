/**
 * @name Accidental rethrow
 * @description When there is nothing to rethrow, attempting to rethrow an exception will terminate the program.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/rethrow-no-exception
 * @tags reliability
 *       correctness
 *       exceptions
 */

import cpp

predicate isInCatch(Expr e) {
  e.getEnclosingStmt().getParent*() instanceof CatchBlock // Lexically enclosing catch blocks will cause there to be a current exception,
  or
  exists(Function f | f = e.getEnclosingFunction() |
    isInCatch(f.getACallToThisFunction()) or // as will dynamically enclosing catch blocks.
    f.getName().toLowerCase().matches("%exception%") // We assume that rethrows are intended when the function is called *exception*.
  )
}

from ReThrowExpr e
where not isInCatch(e)
select e, "As there is no current exception, this rethrow expression will terminate the program."
