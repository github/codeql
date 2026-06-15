import java

from MethodCall c
select c, c.getCallee(), c.getCallee().getDeclaringType(),
  c.getCallee().getDeclaringType().(NestedType).getEnclosingType()
