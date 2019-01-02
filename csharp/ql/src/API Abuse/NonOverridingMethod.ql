/**
 * @name Non-overriding method
 * @description A method looks like it should override a virtual method from a base type, but does not actually do so.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/nonoverriding-method
 * @tags reliability
 *       readability
 *       naming
 */

import csharp

private predicate potentialOverride(Method vm, Method m) {
  vm.getDeclaringType() = m.getDeclaringType().getBaseClass+()
}

/**
 * Holds if method `m` looks like it should override the virtual method `vm`,
 * but does not do so.
 */
predicate nonOverridingMethod(Method m, Method vm) {
  vm.isVirtual() and
  not vm.isOverride() and
  not vm.overrides() and
  potentialOverride(vm, m) and
  not m.overrides() and
  not m.isOverride() and
  not m.isNew() and
  m = m.getSourceDeclaration() and
  m.getNumberOfParameters() = vm.getNumberOfParameters() and
  forall(int i, Parameter p1, Parameter p2 | p1 = m.getParameter(i) and p2 = vm.getParameter(i) |
    p1.getType() = p2.getType()
  ) and
  m.getName().toLowerCase() = vm.getName().toLowerCase()
}

from Method m, Method vm
where
  m.fromSource() and
  nonOverridingMethod(m, vm)
select m, "Method '" + m.getName() + "' looks like it should override $@ but does not do so.",
  vm.getSourceDeclaration(), vm.getQualifiedName()
