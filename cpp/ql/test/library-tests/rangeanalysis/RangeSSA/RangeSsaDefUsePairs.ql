/**
 * @name RangeSsa def-use pairs test
 * @description List all the uses for each RangeSsaDefinition
 * @kind test
 */

import cpp
import semmle.code.cpp.rangeanalysis.RangeSSA

from RangeSsaDefinition def, LocalScopeVariable var, Expr use
where def.getAUse(var) = use
select def, def.toString(var), use
