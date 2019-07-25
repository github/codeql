/**
 * @id java/examples/unusedparam
 * @name Unused parameter
 * @description Finds parameters that are not accessed
 * @tags parameter
 *       access
 */

import java

from Parameter p
where not exists(p.getAnAccess())
select p
