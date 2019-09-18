/**
 * @id cpp/examples/voidreturntype
 * @name Const method without return type
 * @description Finds const methods whose return type is `void`
 * @tags const
 *       function
 *       method
 *       modifier
 *       specifier
 *       return
 *       type
 *       void
 */

import cpp

from MemberFunction m
where
  m.hasSpecifier("const") and
  m.getType() instanceof VoidType
select m
