/**
 * @name Missing enum case in switch
 * @description A switch statement over an enum type is missing a case for some enum constant
 *              and does not have a default case. This may cause logic errors.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/missing-case-in-switch
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-478
 */

import cpp

from EnumSwitch es, float missing, float total, EnumConstant case
where
  not es.hasDefaultCase() and
  missing = count(es.getAMissingCase()) and
  total = missing + count(es.getASwitchCase()) and
  missing / total < 0.3 and
  case = es.getAMissingCase()
select es, "Switch statement does not have a case for $@.", case, case.getName()
