/**
 * @name InitializerCalls
 */

import cpp

from Initializer i, FunctionCall fc
where i.getExpr().getAChild*() = fc
select i, fc
