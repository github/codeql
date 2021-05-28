/**
 * @name Looks for use of a Swallow Everything empty catch block
 * @description Possible indication of Solorigate. The maliciously inserted source was wrapped in a Swallow Everything catch to hide any runtime exceptions
 * @kind problem
 * @tags security
 *       solorigate
 * @precision high
 * @id cs/solorigate/swallow-everything-exception
 * @problem.severity error
 */

import csharp
import Solorigate
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
where gcc.getBlock().getNumberOfStmts() = 0
select gcc, "Empty Swallow Everything Exception."
