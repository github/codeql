/**
 * @name Test for parameters
 */

import csharp
import semmle.code.csharp.commons.Collections

where forall(Parameter p | p.isParams() | p.getType() instanceof ParamsCollectionType)
select 1
