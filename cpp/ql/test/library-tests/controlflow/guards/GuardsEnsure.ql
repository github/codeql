/**
 * @name Guards control test
 * @description List which guards ensure which inequalities apply to which blocks
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.Guards

query predicate binary(
  GuardCondition guard, Expr left, string op, Expr right, int k, int start, int end
) {
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
}

query predicate unary(GuardCondition guard, Expr left, string op, int k, int start, int end) {
  exists(BasicBlock block |
    guard.ensuresLt(left, k, block, true) and op = "<"
    or
    guard.ensuresLt(left, k, block, false) and op = ">="
    or
    guard.ensuresEq(left, k, block, true) and op = "=="
    or
    guard.ensuresEq(left, k, block, false) and op = "!="
  |
    block.hasLocationInfo(_, start, _, end, _)
  )
}
