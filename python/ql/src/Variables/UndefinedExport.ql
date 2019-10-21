/**
 * @name Explicit export is not defined
 * @description Including an undefined attribute in __all__ causes an exception when
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
predicate declaredInAll(Module m, StrConst name)
{
    exists(Assign a, GlobalVariable all | 
        a.defines(all) and a.getScope() = m and
        all.getId() = "__all__" and ((List)a.getValue()).getAnElt() = name
    )
}

predicate mutates_globals(ModuleValue m) {
    exists(CallNode globals |
        globals = Object::builtin("globals").(FunctionObject).getACall() and
        globals.getScope() = m.getScope() |
        exists(AttrNode attr | attr.getObject() = globals)
        or
        exists(SubscriptNode sub | sub.getValue() = globals and sub.isStore())
    )
    or
    exists(Object enum_convert |
        enum_convert.hasLongName("enum.Enum._convert") and
        exists(CallNode call |
            call.getScope() = m.getScope()
            |
            enum_convert.(FunctionObject).getACall() = call or
            call.getFunction().refersTo(enum_convert)
        )
    )
}

from ModuleValue m, StrConst name, string exported_name
where declaredInAll(m.getScope(), name) and
exported_name = name.strValue() and
not m.hasAttribute(exported_name) and
not (m.getScope().getShortName() = "__init__" and exists(m.getScope().getPackage().getSubModule(exported_name))) and
not exists(ImportStarNode imp | imp.getEnclosingModule() = m.getScope() | imp.getModule().pointsTo().isAbsent()) and
not mutates_globals(m)
select name, "The name '" + exported_name  + "' is exported by __all__ but is not defined."