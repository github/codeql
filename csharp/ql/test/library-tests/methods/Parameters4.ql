/**
 * @name Test for parameters
 */

import csharp

where forall(Parameter p | p.isParams() | p.getType() instanceof ArrayType)
select 1
