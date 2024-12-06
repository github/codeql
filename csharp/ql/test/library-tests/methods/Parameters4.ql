/**
 * @name Test for parameters
 */

import csharp

where forall(Parameter p | p.isParams() and p.fromSource() | p.getType() instanceof ArrayType)
select 1
