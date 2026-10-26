/**
 * @name AV Rule 75
 * @description Members of the initialization list shall be listed in the order in which they are declared in the class.
 * @kind problem
 * @id cpp/jsf/av-rule-75
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Diagnostic d
where d.hasTag("out_of_order_ctor_init")
select d,
  "AV Rule 75: Members of the initialization list shall be listed in the order in which they are declared in the class."
