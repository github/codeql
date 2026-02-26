/**
 * @name 'import *' may pollute namespace
 * @description Importing a module using 'import *' may unintentionally pollute the global
 *              namespace if the module does not define `__all__`
 * @kind problem
 * @tags quality
 *       maintainability
 *       readability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/polluting-import
 */

import python
private import semmle.python.dataflow.new.internal.ImportResolution
private import semmle.python.types.ImportTime

predicate all_defined(Module exporter) {
  exporter.(ImportTimeScope).definesName("__all__")
  or
  exporter.getInitModule().(ImportTimeScope).definesName("__all__")
}

from ImportStar imp, Module exporter
where
  exporter = ImportResolution::getModuleImportedByImportStar(imp) and
  not all_defined(exporter)
select imp,
  "Import pollutes the enclosing namespace, as the imported module $@ does not define '__all__'.",
  exporter, exporter.getName()
