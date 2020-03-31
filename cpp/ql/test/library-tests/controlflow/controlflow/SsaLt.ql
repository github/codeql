/**
 * @name Ssa def-use pairs test
 * @description List all an ensured limits.
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.SSA
import semmle.code.cpp.controlflow.Guards

from GuardedSsa def, StackVariable var, Expr other, int k, int start, int end, string op
where
  exists(BasicBlock block |
    def.isLt(var, other, k, block, true) and op = "<"
    or
    def.isLt(var, other, k, block, false) and op = ">"
  |
    block.hasLocationInfo(_, start, _, end, _)
  )
select def, var, op, other, start, end
