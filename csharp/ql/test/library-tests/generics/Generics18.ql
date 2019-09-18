/**
 * @name Test for generic parameter types
 */

import csharp

from Class c, Method m
where
  c.getName().matches("A<%") and
  m = c.getAMethod()
select c, m, m.getAParameter() as p, count(m.(ConstructedMethod).getATypeArgument()),
  p.getType().getName(), count(m.getAParameter()), count(m.getAParameter().getType())
