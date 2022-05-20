/**
 * @name RangeSsa definedByParameter test
 * @description check the results of the definedByParameter method
 * @kind test
 */

import cpp
import semmle.code.cpp.rangeanalysis.RangeSSA

from RangeSsaDefinition def, Parameter p
where def.definedByParameter(p)
select def, p
