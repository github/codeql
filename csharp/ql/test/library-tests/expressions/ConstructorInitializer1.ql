/**
 * @name Test for constructor initializers
 */

import csharp

from InstanceConstructor c, ConstructorInitializer i
where
  c.hasName("Class") and
  i.getEnclosingCallable() = c and
  c.getInitializer() = i and
  c.hasNoParameters() and
  i.getTarget().getDeclaringType() = c.getDeclaringType() and
  i.getTarget().getNumberOfParameters() = 1 and
  i.getArgument(0).getValue() = "0"
select c, i
