/**
 * @name ExprsBasic3
 * @kind table
 */

import cpp

from Function f, FieldAccess fa
where
  f.hasName("create_foo") and
  fa.getEnclosingFunction() = f and
  fa.getTarget().getDeclaringType().hasName("Foo") and
  fa.getTarget().hasName("name")
select f, fa, fa.getTarget()
