/**
 * @name InitializerAccesses
 */

import cpp

from Initializer i, VariableAccess va
where i.getExpr().getAChild*() = va
select i, va
