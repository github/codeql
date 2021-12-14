/**
 * @id java/examples/unusedlocalvar
 * @name Unused local variable
 * @description Finds local variables that are not accessed
 * @tags variable
 *       local
 *       access
 */

import java

from LocalVariableDecl v
where not exists(v.getAnAccess())
select v
