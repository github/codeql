/**
 * @name Property value is not used when setting a property
 * @description Ignoring the value assigned to a property is potentially confusing and
 *              can lead to unexpected results.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/unused-property-value
 * @tags reliability
 *       maintainability
 *       language-features
 */

import csharp

from Setter setter
where
  not exists(setter.getAParameter().getAnAccess()) and
  not exists(ThrowStmt t | t.getEnclosingCallable() = setter) and
  setter.hasBody() and // Trivial setter is OK
  not setter.getDeclaration().overrides() and
  not setter.getDeclaration().implements() and
  not setter.getDeclaration().isVirtual()
select setter, "Value ignored when setting property."
