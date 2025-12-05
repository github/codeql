/**
 * @id py/examples/recursion
 * @name Recursion
 * @description Finds functions that call themselves
 * @tags method
 *       recursion
 */

import python
private import LegacyPointsTo

from PythonFunctionValue f
where f.getACall().getScope() = f.getScope()
select f
