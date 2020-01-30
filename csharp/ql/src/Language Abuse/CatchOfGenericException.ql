/**
 * @name Generic catch clause
 * @description Catching all exceptions with a generic catch clause may be overly
 *              broad, which can make errors harder to diagnose.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/catch-of-all-exceptions
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-396
 */

import csharp
import semmle.code.csharp.frameworks.System

class GenericCatchClause extends CatchClause {
  GenericCatchClause() {
    this instanceof GeneralCatchClause
    or
    this =
      any(SpecificCatchClause scc |
        scc.getCaughtExceptionType() instanceof SystemExceptionClass and
        not scc.hasFilterClause()
      )
  }
}

from GenericCatchClause gcc
where
  forall(ThrowStmt throw |
    // ok to catch all exceptions if they may be rethrown
    gcc.getBlock().getAChildStmt+() = throw
  |
    exists(throw.getExpr())
  )
select gcc, "Generic catch clause."
