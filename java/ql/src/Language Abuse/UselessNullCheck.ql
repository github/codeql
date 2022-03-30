/**
 * @name Useless null check
 * @description Checking whether an expression is null when that expression cannot
 *              possibly be null is useless.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/useless-null-check
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.dataflow.NullGuards
import semmle.code.java.controlflow.Guards

from Expr guard, Expr e, Expr reason, string msg
where
  guard = basicNullGuard(e, _, true) and
  e = clearlyNotNullExpr(reason) and
  (
    if reason instanceof Guard
    then msg = "This check is useless, $@ cannot be null here, since it is guarded by $@."
    else
      if reason != e
      then msg = "This check is useless, $@ cannot be null here, since $@ always is non-null."
      else msg = "This check is useless, since $@ always is non-null."
  )
select guard, msg, e, e.toString(), reason, reason.toString()
