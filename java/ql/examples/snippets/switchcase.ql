/**
 * @id java/examples/switchcase
 * @name Switch statement case missing
 * @description Finds switch statements with a missing enum constant case and no default case
 * @tags switch
 *       case
 *       enum
 */

import java

from SwitchStmt switch, EnumType enum, EnumConstant missing
where
  switch.getExpr().getType() = enum and
  missing.getDeclaringType() = enum and
  not switch.getAConstCase().getValue() = missing.getAnAccess() and
  not exists(switch.getDefaultCase())
select switch
