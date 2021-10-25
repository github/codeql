import cpp
import semmle.code.cpp.controlflow.IRGuards

query predicate astGuards(GuardCondition guard) { any() }

query predicate astGuardsCompare(int startLine, string msg) {
  exists(GuardCondition guard, Expr left, Expr right, int k, string which, string op |
    exists(boolean sense |
      sense = true and which = "true"
      or
      sense = false and which = "false"
    |
      guard.comparesLt(left, right, k, true, sense) and op = " < "
      or
      guard.comparesLt(left, right, k, false, sense) and op = " >= "
      or
      guard.comparesEq(left, right, k, true, sense) and op = " == "
      or
      guard.comparesEq(left, right, k, false, sense) and op = " != "
    ) and
    startLine = guard.getLocation().getStartLine() and
    msg = left + op + right + "+" + k + " when " + guard + " is " + which
  )
}

query predicate astGuardsControl(GuardCondition guard, boolean sense, int start, int end) {
  exists(BasicBlock block |
    guard.controls(block, sense) and
    block.hasLocationInfo(_, start, _, end, _)
  )
}

query predicate astGuardsEnsure(
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

query predicate irGuards(IRGuardCondition guard) { any() }

query predicate irGuardsCompare(int startLine, string msg) {
  exists(IRGuardCondition guard, Operand left, Operand right, int k, string which, string op |
    exists(boolean sense |
      sense = true and which = "true"
      or
      sense = false and which = "false"
    |
      guard.comparesLt(left, right, k, true, sense) and op = " < "
      or
      guard.comparesLt(left, right, k, false, sense) and op = " >= "
      or
      guard.comparesEq(left, right, k, true, sense) and op = " == "
      or
      guard.comparesEq(left, right, k, false, sense) and op = " != "
    ) and
    startLine = guard.getLocation().getStartLine() and
    msg =
      left.getAnyDef().getUnconvertedResultExpression() + op +
        right.getAnyDef().getUnconvertedResultExpression() + "+" + k + " when " + guard + " is " +
        which
  )
}

query predicate irGuardsControl(IRGuardCondition guard, boolean sense, int start, int end) {
  exists(IRBlock block |
    guard.controls(block, sense) and
    block.getLocation().hasLocationInfo(_, start, _, end, _)
  )
}

query predicate irGuardsEnsure(
  IRGuardCondition guard, Instruction left, string op, Instruction right, int k, int start, int end
) {
  exists(IRBlock block, Operand leftOp, Operand rightOp |
    guard.ensuresLt(leftOp, rightOp, k, block, true) and op = "<"
    or
    guard.ensuresLt(leftOp, rightOp, k, block, false) and op = ">="
    or
    guard.ensuresEq(leftOp, rightOp, k, block, true) and op = "=="
    or
    guard.ensuresEq(leftOp, rightOp, k, block, false) and op = "!="
  |
    leftOp = left.getAUse() and
    rightOp = right.getAUse() and
    block.getLocation().hasLocationInfo(_, start, _, end, _)
  )
}
