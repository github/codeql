/**
 * @name 'import *' may pollute namespace
 * @description Importing a module using 'import *' may unintentionally pollute the global
 *              namespace if the module does not define `__all__`
 * @kind problem
 * @tags maintainability
 *       modularity
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/polluting-import
 */

import python

predicate import_star(ImportStar imp, ModuleValue exporter) {
  exporter.importedAs(imp.getImportedModuleName())
}

predicate all_defined(ModuleValue exporter) {
  exporter.isBuiltin()
  or
  exporter.getScope().(ImportTimeScope).definesName("__all__")
  or
  exporter.getScope().getInitModule().(ImportTimeScope).definesName("__all__")
}

from ImportStar imp, ModuleValue exporter
where import_star(imp, exporter) and not all_defined(exporter) and not exporter.isAbsent()
select imp,
  "Import pollutes the enclosing namespace, as the imported module $@ does not define '__all__'.",
  exporter, exporter.getName()
