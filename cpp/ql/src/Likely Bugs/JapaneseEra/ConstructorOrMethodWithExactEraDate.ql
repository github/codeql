/**
 * @name ConstructingJapaneseEraStartDate
 * @description Japanese era changes can lead to code behaving differently. Aviod hard-coding Japanese era start dates. The values should be read from registry.
 * @kind problem
 * @problem.severity warning
 * @id cpp/JapaneseEra/Constructor-Or-Method-With-Exact-Era-Date
 * @precision medium
 * @tags reliability
 *       japanese-era
 */

import cpp
from Call cc, int i
where cc.getArgument(i).getValue().toInt() = 1989 and
      cc.getArgument(i+1).getValue().toInt() = 1 and
      cc.getArgument(i+2).getValue().toInt() = 8
select cc, "Call that appears to have hard-coded Japanese era start date as parameter" 
