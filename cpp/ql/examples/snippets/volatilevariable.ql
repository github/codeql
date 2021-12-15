/**
 * @id cpp/examples/volatilevariable
 * @name Variable declared volatile
 * @description Finds variables with a `volatile` modifier
 * @tags variable
 *       volatile
 */

import cpp

from Variable f
where f.isVolatile()
select f
