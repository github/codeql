/**
 * @name Ssa definedByParameter test
 * @description check the results of the definedByParameter method
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA

from SsaDefinition def, Parameter p
where def.definedByParameter(p)
select def, p
