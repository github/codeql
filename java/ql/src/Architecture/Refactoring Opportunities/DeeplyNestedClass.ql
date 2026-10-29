/**
 * @name Deeply-nested class
 * @description Deeply-nested classes are difficult to understand, since they have access to many scopes
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/deeply-nested-class
 * @tags testability
 */

import java

from NestedClass c
where
  c.getNestingDepth() > 1 and
  exists(Method m | m.getDeclaringType() = c | not m instanceof StaticInitializer) and
  not c instanceof AnonymousClass and
  not c instanceof EnumType
select c, "This class is deeply nested, which can hinder readability."
