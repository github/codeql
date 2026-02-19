/**
 * @name Use of a print statement at module level
 * @description Using a print statement at module scope (except when guarded by `if __name__ == '__main__'`) will cause surprising output when the module is imported.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
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

/**
 * Holds if module `m` is likely used as a module (imported by another module),
 * as opposed to being exclusively used as a script.
 */
predicate is_used_as_module(Module m) {
  m.isPackageInit()
  or
  exists(ImportingStmt i | i.getAnImportedModuleName() = m.getName())
}

from Stmt p
where
  is_print_stmt(p) and
  is_used_as_module(p.getScope()) and
  not exists(If i | main_eq_name(i) and i.getASubStatement().getASubStatement*() = p)
select p, "Print statement may execute during import."
