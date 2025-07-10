/**
 * @name Use of a print statement at module level
 * @description Using a print statement at module scope (except when guarded by `if __name__ == '__main__'`) will cause surprising output when the module is imported.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/print-during-import
 */

import python

predicate main_eq_name(If i) {
  exists(Name n, StringLiteral m, Compare c |
    i.getTest() = c and
    c.getLeft() = n and
    c.getAComparator() = m and
    n.getId() = "__name__" and
    m.getText() = "__main__"
  )
}

predicate is_print_stmt(Stmt s) {
  s instanceof Print
  or
  exists(ExprStmt e, Call c, Name n |
    e = s and c = e.getValue() and n = c.getFunc() and n.getId() = "print"
  )
}

from Stmt p
where
  is_print_stmt(p) and
  // TODO: Need to discuss how we would like to handle ModuleObject.getKind in the glorious future
  exists(ModuleValue m | m.getScope() = p.getScope() and m.isUsedAsModule()) and
  not exists(If i | main_eq_name(i) and i.getASubStatement().getASubStatement*() = p)
select p, "Print statement may execute during import."
