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

EnumConstant nthMissing(SwitchStmt switch, int index) {
  not exists(switch.getDefaultCase()) and
  exists(EnumType enum |
    switch.getExpr().getType() = enum and
    result =
      rank[index](EnumConstant ec |
        ec.getDeclaringType() = enum and
        not switch.getAConstCase().getValue() = ec.getAnAccess()
      |
        ec order by ec.getName()
      )
  )
}

predicate first3(string msg, SwitchStmt switch, EnumConstant e1, EnumConstant e2, EnumConstant e3) {
  exists(int n | n = strictcount(nthMissing(switch, _)) |
    if n > 3
    then msg = "Switch statement does not have a case for $@, $@, $@, or " + (n - 3) + " more."
    else msg = "Switch statement does not have a case for $@, $@, or $@."
  ) and
  e1 = nthMissing(switch, 1) and
  e2 = nthMissing(switch, 2) and
  e3 = nthMissing(switch, 3)
}

predicate only2(string msg, SwitchStmt switch, EnumConstant e1, EnumConstant e2) {
  msg = "Switch statement does not have a case for $@ or $@." and
  e1 = nthMissing(switch, 1) and
  e2 = nthMissing(switch, 2)
}

predicate only1(string msg, SwitchStmt switch, EnumConstant e) {
  msg = "Switch statement does not have a case for $@." and
  e = nthMissing(switch, 1)
}

from string msg, SwitchStmt switch, EnumConstant e1, EnumConstant e2, EnumConstant e3
where
  if first3(_, switch, _, _, _)
  then first3(msg, switch, e1, e2, e3)
  else
    if only2(_, switch, _, _)
    then (
      only2(msg, switch, e1, e2) and e1 = e3
    ) else (
      only1(msg, switch, e1) and e1 = e2 and e1 = e3
    )
select switch, msg, e1, e1.getName(), e2, e2.getName(), e3, e3.getName()
