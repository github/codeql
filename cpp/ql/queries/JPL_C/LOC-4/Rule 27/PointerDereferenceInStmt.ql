/**
 * @name Too many pointer dereferences in statement
 * @description Statements should contain no more than two levels of dereferencing per object.
 * @kind problem
 * @id cpp/jpl-c/pointer-dereference-in-stmt
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from PointerDereferenceExpr e, int n
where
  not e.getParent+() instanceof PointerDereferenceExpr and
  n = strictcount(PointerDereferenceExpr child | child.getParent+() = e) and
  n > 1
select e, "This expression involves " + n + " levels of pointer dereference; 2 are allowed."
