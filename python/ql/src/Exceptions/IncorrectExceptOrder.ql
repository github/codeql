/**
 * @name Unreachable `except` block
 * @description Handling general exceptions before specific exceptions means that the specific
 *              handlers are never executed.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 *       external/cwe/cwe-561
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/unreachable-except
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
private import ExceptionTypes

predicate incorrectExceptOrder(ExceptStmt ex1, ExceptType cls1, ExceptStmt ex2, ExceptType cls2) {
  exists(int i, int j, Try t |
    ex1 = t.getHandler(i) and
    ex2 = t.getHandler(j) and
    i < j and
    cls1 = exceptClass(ex1) and
    cls2 = exceptClass(ex2) and
    cls1 = cls2.getADirectSuperclass*()
  )
}

ExceptType exceptClass(ExceptStmt ex) { ex.getType() = result.getAUse().asExpr() }

from ExceptStmt ex1, ExceptType cls1, ExceptStmt ex2, ExceptType cls2, string msg
where
  incorrectExceptOrder(ex1, cls1, ex2, cls2) and
  if cls1 = cls2
  then msg = "This except block handling $@ is unreachable; as $@ also handles $@."
  else
    msg =
      "This except block handling $@ is unreachable; as $@ for the more general $@ always subsumes it."
select ex2, msg, cls2, cls2.getName(), ex1, "this except block", cls1, cls1.getName()
