/**
 * @name Module is imported with 'import' and 'import from'
 * @description A module is imported with the "import" and "import from" statements
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/import-and-import-from
 */

import python

predicate import_and_import_from(Import i1, Import i2, Module m) {
  i1.getEnclosingModule() = i2.getEnclosingModule() and
  exists(ImportExpr e1, ImportExpr e2, ImportMember im |
    e1 = i1.getAName().getValue() and im = i2.getAName().getValue() and e2 = im.getModule()
  |
    e1.getName() = m.getName() and e2.getName() = m.getName()
  )
}

from Stmt i1, Stmt i2, Module m
where import_and_import_from(i1, i2, m)
select i1, "Module '" + m.getName() + "' is imported with both 'import' and 'import from'"
