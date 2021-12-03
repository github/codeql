/**
 * @id cpp/examples/unusedlocalvar
 * @name Unused local variable
 * @description Finds local variables that are not accessed
 * @tags variable
 *       local
 *       access
 */

import cpp

from LocalScopeVariable v
where
  not v instanceof Parameter and
  not exists(v.getAnAccess())
select v
