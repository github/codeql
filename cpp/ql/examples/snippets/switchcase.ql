/**
 * @id cpp/examples/switchcase
 * @name Switch statement case missing
 * @description Finds switch statements with a missing enum constant case
 *              and no default case
 * @tags switch
 *       case
 *       enum
 */

import cpp

from EnumSwitch es, EnumConstant ec
where
  ec = es.getAMissingCase() and
  not es.hasDefaultCase()
select es, ec
