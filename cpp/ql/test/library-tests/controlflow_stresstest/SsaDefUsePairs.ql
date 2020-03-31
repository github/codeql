/**
 * @name Ssa def-use pairs test
 * @description List all the uses for each SsaDefinition
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA

from SsaDefinition def, StackVariable var, Expr use
where def.getAUse(var) = use
select def, def.toString(var), use
