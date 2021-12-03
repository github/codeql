/**
 * @name Guards control test
 * @description List which guards ensure which inequalities apply to which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.Guards

from GuardCondition guard, Expr left, Expr right, int k, int start, int end, string op
where
  exists(BasicBlock block |
    guard.ensuresLt(left, right, k, block, true) and op = "<"
    or
    guard.ensuresLt(left, right, k, block, false) and op = ">="
    or
    guard.ensuresEq(left, right, k, block, true) and op = "=="
    or
    guard.ensuresEq(left, right, k, block, false) and op = "!="
  |
    block.hasLocationInfo(_, start, _, end, _)
  )
select guard, left, op, right, k, start, end
