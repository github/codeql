/**
 * @name Unnecessary pass
 * @description Unnecessary 'pass' statement
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/unnecessary-pass
 */

import python

predicate is_doc_string(ExprStmt s) {
  s.getValue() instanceof Unicode or s.getValue() instanceof Bytes
}

predicate has_doc_string(StmtList stmts) {
  stmts.getParent() instanceof Scope and
  is_doc_string(stmts.getItem(0))
}

from Pass p, StmtList list
where
  list.getAnItem() = p and
  (
    strictcount(list.getAnItem()) = 2 and not has_doc_string(list)
    or
    strictcount(list.getAnItem()) > 2
  )
select p, "Unnecessary 'pass' statement."
