/**
 * @name Cyclic import
 * @description Module forms part of an import cycle, thereby indirectly importing itself.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       modularity
 * @problem.severity recommendation
 * @sub-severity low
 * @precision high
 * @id py/cyclic-import
 */

import python
import CyclicImports
private import semmle.python.dataflow.new.internal.ImportResolution

from Module m1, Module m2, Stmt imp
where
  imp.getEnclosingModule() = m1 and
  stmt_imports(imp) = m2 and
  circular_import(m1, m2) and
  m1 != m2 and
  // this query finds all cyclic imports that are *not* flagged by ModuleLevelCyclicImport
  not failing_import_due_to_cycle(m2, m1, _, _, _, _) and
  not exists(If i | i.isNameEqMain() and i.contains(imp))
select imp, "Import of module $@ begins an import cycle.", m2, ImportResolution::moduleName(m2)
