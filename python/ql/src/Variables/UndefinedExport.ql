/**
 * @name Explicit export is not defined
 * @description Including an undefined attribute in `__all__` causes an exception when
 *              the module is imported using '*'
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/undefined-export
 */

import python
private import semmle.python.dataflow.new.internal.ImportResolution
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs

/** Whether name is declared in the __all__ list of this module */
predicate declaredInAll(Module m, StringLiteral name) {
  exists(Assign a, GlobalVariable all |
    a.defines(all) and
    a.getScope() = m and
    all.getId() = "__all__" and
    a.getValue().(List).getAnElt() = name
  )
}

predicate mutates_globals(Module m) {
  exists(CallNode globals |
    globals = API::builtin("globals").getACall().asCfgNode() and
    globals.getScope() = m
  |
    exists(AttrNode attr | attr.getObject() = globals)
    or
    exists(SubscriptNode sub | sub.getObject() = globals and sub.isStore())
  )
  or
  // Enum._convert_ is a metaclass method that alters the module's globals.
  // It was called `_convert` until Python 3.8, when it was renamed to `_convert_`.
  API::moduleImport("enum")
      .getMember("Enum")
      .getASubclass*()
      .getMember(["_convert", "_convert_"])
      .getACall()
      .getScope() = m
}

predicate is_exported_submodule_name(Module m, string exported_name) {
  m.getShortName() = "__init__" and
  exists(m.getPackage().getSubModule(exported_name))
}

predicate contains_unknown_import_star(Module m) {
  exists(ImportStar imp | imp.getScope() = m |
    not exists(ImportResolution::getModuleImportedByImportStar(imp))
  )
}

from Module m, StringLiteral name, string exported_name
where
  declaredInAll(m, name) and
  exported_name = name.getText() and
  not ImportResolution::module_export(m, exported_name, _) and
  not is_exported_submodule_name(m, exported_name) and
  not contains_unknown_import_star(m) and
  not mutates_globals(m)
select name, "The name '" + exported_name + "' is exported by __all__ but is not defined."
