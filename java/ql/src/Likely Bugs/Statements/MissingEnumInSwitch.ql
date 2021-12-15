/**
 * @name Missing enum case in switch
 * @description A 'switch' statement that is based on an 'enum' type and does not have cases for all
 *              the 'enum' constants is usually a coding mistake.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/missing-case-in-switch
 * @tags reliability
 *       readability
 *       external/cwe/cwe-478
 */

import java

from SwitchStmt switch, EnumType enum, EnumConstant missing
where
  switch.getExpr().getType() = enum and
  missing.getDeclaringType() = enum and
  not exists(switch.getDefaultCase()) and
  not switch.getAConstCase().getValue() = missing.getAnAccess()
select switch, "Switch statement does not have a case for $@.", missing, missing.getName()
