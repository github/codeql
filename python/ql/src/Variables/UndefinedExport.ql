/**
 * @name Explicit export is not defined
 * @description Including an undefined attribute in `__all__` causes an exception when
 *              the module is imported using '*'
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/undefined-export
 */

import python

/** Whether name is declared in the __all__ list of this module */
predicate declaredInAll(Module m, StrConst name) {
  exists(Assign a, GlobalVariable all |
    a.defines(all) and
    a.getScope() = m and
    all.getId() = "__all__" and
    a.getValue().(List).getAnElt() = name
  )
}

predicate mutates_globals(ModuleValue m) {
  exists(CallNode globals |
    globals = Value::named("globals").(FunctionValue).getACall() and
    globals.getScope() = m.getScope()
  |
    exists(AttrNode attr | attr.getObject() = globals)
    or
    exists(SubscriptNode sub | sub.getObject() = globals and sub.isStore())
  )
  or
  // Enum (added in 3.4) has method `_convert_` that alters globals
  // This was called `_convert` until 3.8, but that name will be removed in 3.9
  exists(ClassValue enum_class |
    enum_class.getASuperType() = Value::named("enum.Enum") and
    (
      // In Python < 3.8, Enum._convert can be found with points-to
      exists(Value enum_convert |
        enum_convert = enum_class.attr("_convert") and
        exists(CallNode call | call.getScope() = m.getScope() |
          enum_convert.getACall() = call or
          call.getFunction().pointsTo(enum_convert)
        )
      )
      or
      // In Python 3.8, Enum._convert_ is implemented using a metaclass, and our points-to
      // analysis doesn't handle that well enough. So we need a special case for this
      not exists(enum_class.attr("_convert")) and
      exists(CallNode call | call.getScope() = m.getScope() |
        call.getFunction().(AttrNode).getObject(["_convert", "_convert_"]).pointsTo() = enum_class
      )
    )
  )
}

predicate is_exported_submodule_name(ModuleValue m, string exported_name) {
  m.getScope().getShortName() = "__init__" and
  exists(m.getScope().getPackage().getSubModule(exported_name))
}

predicate contains_unknown_import_star(ModuleValue m) {
  exists(ImportStarNode imp | imp.getEnclosingModule() = m.getScope() |
    imp.getModule().pointsTo().isAbsent()
    or
    not exists(imp.getModule().pointsTo())
  )
}

from ModuleValue m, StrConst name, string exported_name
where
  declaredInAll(m.getScope(), name) and
  exported_name = name.getText() and
  not m.hasAttribute(exported_name) and
  not is_exported_submodule_name(m, exported_name) and
  not contains_unknown_import_star(m) and
  not mutates_globals(m)
select name, "The name '" + exported_name + "' is exported by __all__ but is not defined."
