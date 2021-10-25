/**
 * @name Test for constructors
 */

import csharp

from Constructor c
where
  c.getNumberOfParameters() = 1 and
  c.getParameter(0).getName() = "i" and
  c.getParameter(0).getType() instanceof IntType and
  c.fromSource()
select c, c.getAParameter()
