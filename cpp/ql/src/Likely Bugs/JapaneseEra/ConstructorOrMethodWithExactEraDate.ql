/**
 * @name Hard-coded Japanese era start date
 * @description Japanese era changes can lead to code behaving differently. Avoid hard-coding Japanese era start dates.
 * @kind problem
 * @problem.severity warning
 * @id cpp/japanese-era/constructor-or-method-with-exact-era-date
 * @precision medium
 * @tags reliability
 *       japanese-era
 */

import cpp

from Call cc, int i
where
  cc.getArgument(i).getValue().toInt() = 1989 and
  cc.getArgument(i + 1).getValue().toInt() = 1 and
  cc.getArgument(i + 2).getValue().toInt() = 8
select cc, "Call that appears to have hard-coded Japanese era start date as parameter."
