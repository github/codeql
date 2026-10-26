/**
 * @name Test for constructor initializers
 */

import csharp

from InstanceConstructor c, ConstructorInitializer i
where
  c.hasName("Nested") and
  i.getEnclosingCallable() = c and
  c.getInitializer() = i and
  c.getNumberOfParameters() = 1 and
  i.getTarget().getDeclaringType() = c.getDeclaringType().getBaseClass() and
  i.getTarget().getNumberOfParameters() = 1 and
  i.getArgument(0) instanceof AddExpr
select c, i
