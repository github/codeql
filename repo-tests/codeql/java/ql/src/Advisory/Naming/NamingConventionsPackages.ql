/**
 * @name Misnamed package
 * @description A package name that contains uppercase letters decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/misnamed-package
 * @tags maintainability
 */

import java

from RefType t, Package p
where
  p = t.getPackage() and
  t.fromSource() and
  not p.getName().toLowerCase() = p.getName()
select t,
  "This type belongs to the package " + p.getName() +
    ", which should not include uppercase letters."
