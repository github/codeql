/**
 * @name Use of an undefined placeholder variable
 * @description Using a variable before it is initialized causes an exception.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision medium
 * @id py/undefined-placeholder-variable
 */

import python
private import semmle.python.dataflow.new.internal.ImportResolution
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.types.ImportTime

/* Global Stuff */
predicate not_a_global(PlaceHolder use) {
  not ImportResolution::module_export(use.getEnclosingModule(), use.getId(), _) and
  not DuckTyping::globallyDefinedName(use.getId()) and
  not DuckTyping::monkeyPatchedBuiltin(use.getId())
}

/* Local variable part */
predicate initialized_as_local(PlaceHolder use) {
  exists(SsaVariable l, Function f | f = use.getScope() and l.getAUse() = use.getAFlowNode() |
    l.getVariable() instanceof LocalVariable and
    exists(l.getDefinition()) and
    not l.getDefinition().isDelete()
  )
}

/* Not a template member */
Class enclosing_class(PlaceHolder use) { result.getAMethod() = use.getScope() }

predicate template_attribute(PlaceHolder use) {
  exists(ImportTimeScope cls | cls = enclosing_class(use) | cls.definesName(use.getId()))
}

from PlaceHolder p
where
  not initialized_as_local(p) and
  not template_attribute(p) and
  not_a_global(p)
select p, "This use of place-holder variable '" + p.getId() + "' may be undefined."
