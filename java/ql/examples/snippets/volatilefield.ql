/**
 * @id java/examples/volatilefield
 * @name Fields declared volatile
 * @description Finds fields with a 'volatile' modifier
 * @tags field
 *       volatile
 *       synchronization
 */

import java

from Field f
where f.isVolatile()
select f
