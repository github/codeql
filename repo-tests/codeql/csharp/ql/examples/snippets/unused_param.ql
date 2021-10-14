/**
 * @id cs/examples/unused-param
 * @name Unused parameter
 * @description Finds parameters that are not accessed.
 * @tags parameter
 *       access
 */

import csharp

from Parameter p
where not exists(p.getAnAccess())
select p
