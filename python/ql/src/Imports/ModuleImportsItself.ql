/**
 * @name Module imports itself
 * @description A module imports itself
 * @kind problem
 * @tags quality
 *       maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/import-own-module
 */

import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.ImportResolution

predicate modules_imports_itself(ImportingStmt i, Module m) {
  m = i.getEnclosingModule() and
  ImportResolution::importedBy(i, m) and
  // Exclude `from m import submodule` where the imported member is a submodule of m
  not exists(ImportMember im | im = i.(Import).getAName().getValue() |
    ImportResolution::getImmediateModuleReference(m).asExpr() = im.getModule() and
    ImportResolution::importedBy(i, any(Module sub | sub != m))
  )
}

from ImportingStmt i, Module m
where modules_imports_itself(i, m)
select i, "The module '" + ImportResolution::moduleName(m) + "' imports itself."
