/**
 * @name Non-exception in 'except' clause
 * @description An exception handler specifying a non-exception type will never handle any exception.
 * @kind problem
 * @tags reliability
 *       correctness
 *       types
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/useless-except
 */

import python

from ExceptFlowNode ex, Value t, ClassValue c, ControlFlowNode origin, string what
where
  ex.handledException(t, c, origin) and
  (
    exists(ClassValue x | x = t |
      not x.isLegalExceptionType() and
      not x.failedInference(_) and
      what = "class '" + x.getName() + "'"
    )
    or
    not t instanceof ClassValue and
    what = "instance of '" + c.getName() + "'"
  )
select ex.getNode(),
  "Non-exception $@ in exception handler which will never match raised exception.", origin, what
