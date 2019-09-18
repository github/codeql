/**
 * @name 'import *' may pollute namespace
 * @description Importing a module using 'import *' may unintentionally pollute the global
 *              namespace if the module does not define '__all__'
 * @kind problem
 * @tags maintainability
 *       modularity
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/polluting-import
 */

import python

predicate import_star(ImportStar imp, ModuleObject exporter) {
    exporter.importedAs(imp.getImportedModuleName())
}

predicate all_defined(ModuleObject exporter) {
    exporter.isC()
    or
    exporter.getModule().(ImportTimeScope).definesName("__all__")
    or
    exporter.getModule().getInitModule().(ImportTimeScope).definesName("__all__")
}


from ImportStar imp, ModuleObject exporter
where import_star(imp, exporter) and not all_defined(exporter)
select imp, "Import pollutes the enclosing namespace, as the imported module $@ does not define '__all__'.",
       exporter, exporter.getName()
