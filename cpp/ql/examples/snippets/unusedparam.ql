/**
 * @id cpp/examples/unusedparam
 * @name Unused parameter
 * @description Finds parameters that are not accessed
 * @tags parameter
 *       access
 */

import cpp

from Parameter p
where p.isNamed() and not exists(p.getAnAccess())
select p
