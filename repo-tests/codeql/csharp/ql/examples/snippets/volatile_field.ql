/**
 * @id cs/examples/volatile-field
 * @name Fields declared volatile
 * @description Finds fields with a 'volatile' modifier.
 * @tags field
 *       volatile
 *       synchronization
 */

import csharp

from Field f
where f.isVolatile()
select f
