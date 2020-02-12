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

predicate modules_imports_itself(Import i, ModuleValue m) {
    i.getEnclosingModule() = m.getScope() and
    m.importedAs(i.getAnImportedModuleName())
}

from Import i, ModuleValue m
where modules_imports_itself(i, m)
select i, "The module '" + m.getName() + "' imports itself."
