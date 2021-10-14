/**
 * @name Unreachable 'except' block
 * @description Handling general exceptions before specific exceptions means that the specific
 *              handlers are never executed.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-561
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/unreachable-except
 */

import python

predicate incorrect_except_order(ExceptStmt ex1, ClassValue cls1, ExceptStmt ex2, ClassValue cls2) {
  exists(int i, int j, Try t |
    ex1 = t.getHandler(i) and
    ex2 = t.getHandler(j) and
    i < j and
    cls1 = except_class(ex1) and
    cls2 = except_class(ex2) and
    cls1 = cls2.getASuperType()
  )
}

ClassValue except_class(ExceptStmt ex) { ex.getType().pointsTo(result) }

from ExceptStmt ex1, ClassValue cls1, ExceptStmt ex2, ClassValue cls2
where incorrect_except_order(ex1, cls1, ex2, cls2)
select ex2,
  "Except block for $@ is unreachable; the more general $@ for $@ will always be executed in preference.",
  cls2, cls2.getName(), ex1, "except block", cls1, cls1.getName()
