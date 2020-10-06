/**
 * @name Test for enums
 */

import csharp

from Expr e
where
  exists(Assignment a | a.getRValue() = e |
    a.getParent().(Field).getDeclaringType() instanceof Enum
  )
select e, e.getValue()
