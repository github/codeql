/**
 * @name Unused exception object
 * @description An exception object is created, but is not used.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/unused-exception-object
 */

import python

from Call call, ClassValue ex
where
  call.getFunc().pointsTo(ex) and
  ex.getASuperType() = ClassValue::exception() and
  exists(ExprStmt s | s.getValue() = call)
select call, "Instantiating an exception, but not raising it, has no effect"
