/**
 * @name Use of an undefined placeholder variable
 * @description Using a variable before it is initialized causes an exception.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision medium
 * @id py/undefined-placeholder-variable
 */

import python
import Variables.MonkeyPatched

/* Local variable part */
predicate initialized_as_local(PlaceHolder use) {
  exists(SsaVariable l, Function f | f = use.getScope() and l.getAUse() = use.getAFlowNode() |
    l.getVariable() instanceof LocalVariable and
    not l.maybeUndefined()
  )
}

/* Not a template member */
Class enclosing_class(PlaceHolder use) { result.getAMethod() = use.getScope() }

predicate template_attribute(PlaceHolder use) {
  exists(ImportTimeScope cls | cls = enclosing_class(use) | cls.definesName(use.getId()))
}

/* Global Stuff */
predicate not_a_global(PlaceHolder use) {
  not exists(PythonModuleObject mo |
    mo.hasAttribute(use.getId()) and mo.getModule() = use.getEnclosingModule()
  ) and
  not globallyDefinedName(use.getId()) and
  not monkey_patched_builtin(use.getId()) and
  not globallyDefinedName(use.getId())
}

from PlaceHolder p
where
  not initialized_as_local(p) and
  not template_attribute(p) and
  not_a_global(p)
select p, "This use of place-holder variable '" + p.getId() + "' may be undefined"
