/**
 * @id py/examples/call
 * @name Calls to function
 * @description Finds calls to any function named "len"
 * @tags call
 *       function
 */

import python

from Value len, CallNode call
where len.getName() = "len" and len.getACall() = call
select call
