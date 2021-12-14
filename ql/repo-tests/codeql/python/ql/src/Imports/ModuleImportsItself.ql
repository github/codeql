/**
 * @name Module imports itself
 * @description A module imports itself
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/import-own-module
 */

import python

predicate modules_imports_itself(ImportingStmt i, ModuleValue m) {
  i.getEnclosingModule() = m.getScope() and
  m =
    max(string s, ModuleValue m_ |
      s = i.getAnImportedModuleName() and
      m_.importedAs(s)
    |
      m_ order by s.length()
    )
}

from ImportingStmt i, ModuleValue m
where modules_imports_itself(i, m)
select i, "The module '" + m.getName() + "' imports itself."
