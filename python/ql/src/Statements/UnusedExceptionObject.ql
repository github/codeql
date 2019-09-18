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

from Call call, ClassObject ex
where call.getFunc().refersTo(ex) and ex.getAnImproperSuperType() = theExceptionType()
and exists(ExprStmt s | s.getValue() = call)

select call, "Instantiating an exception, but not raising it, has no effect"
