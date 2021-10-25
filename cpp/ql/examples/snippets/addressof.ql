/**
 * @id cpp/examples/addressof
 * @name Address of reference variable
 * @description Finds address-of expressions (`&`) that take the address
 *              of a reference variable
 * @tags addressof
 *       reference
 */

import cpp

from AddressOfExpr addr, VariableAccess access
where
  access = addr.getOperand() and
  access.getTarget().getType() instanceof ReferenceType
select addr
