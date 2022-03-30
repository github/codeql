/**
 * @name Missing catch of NumberFormatException
 * @description Calling a string to number conversion method without handling
 *              'NumberFormatException' may cause unexpected runtime exceptions.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/uncaught-number-format-exception
 * @tags reliability
 *       external/cwe/cwe-248
 */

import java
import semmle.code.java.NumberFormatException

from Expr e
where
  throwsNFE(e) and
  not exists(TryStmt t |
    t.getBlock() = e.getEnclosingStmt().getEnclosingStmt*() and
    catchesNFE(t)
  ) and
  not exists(Callable c |
    e.getEnclosingCallable() = c and
    c.getAThrownExceptionType().getADescendant() instanceof NumberFormatException
  )
select e, "Potential uncaught 'java.lang.NumberFormatException'."
