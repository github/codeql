/**
 * @name Misnamed class or interface
 * @description A class or interface name that begins with a lowercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/misnamed-type
 * @tags maintainability
 */

import java

from RefType t
where
  t.fromSource() and
  not t instanceof AnonymousClass and
  not t.getName().substring(0, 1).toUpperCase() = t.getName().substring(0, 1)
select t, "Class and interface names should start in uppercase."
