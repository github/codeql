/**
 * @id cs/examples/switch-case
 * @name Switch statement case missing
 * @description Finds switch statements with a missing enum constant case and no default case.
 * @tags switch
 *       case
 *       enum
 */

import csharp

from SwitchStmt switch, Enum enum, EnumConstant missing
where
  switch.getCondition().getType() = enum and
  missing.getDeclaringType() = enum and
  not switch.getAConstCase().getExpr() = missing.getAnAccess() and
  not exists(switch.getDefaultCase())
select switch
