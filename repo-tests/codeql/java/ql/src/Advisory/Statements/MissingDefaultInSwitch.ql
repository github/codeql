/**
 * @name Missing default case in switch
 * @description A 'switch' statement that is based on a non-enumerated type and that does not have a
 *              'default' case may allow execution to 'fall through' silently.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/missing-default-in-switch
 * @tags reliability
 *       external/cwe/cwe-478
 */

import java

from SwitchStmt switch
where
  not switch.getExpr().getType() instanceof EnumType and
  not exists(switch.getDefaultCase())
select switch, "Switch statement does not have a default case."
