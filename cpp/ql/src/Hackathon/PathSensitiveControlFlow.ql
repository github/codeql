/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.controlflow.Guards

string interpretUnaryOperation(UnaryOperation unary, Expr arg) {
  unary instanceof NotExpr and
  result = "(not " + interpretExpr(arg) + ")"
}

string interpretBinaryOperation(BinaryOperation binary, Expr arg1, Expr arg2) {
  exists(string s1, string s2 |
    s1 = interpretExpr(arg1) and
    s2 = interpretExpr(arg2)
  |
    binary instanceof LogicalAndExpr and
    result = "(and " + arg1 + " " + arg2 + ")"
    or
    binary instanceof LogicalOrExpr and
    result = "(or " + arg1 + " " + arg2 + ")"
    or
    binary instanceof EQExpr and
    result = "(= " + arg1 + " " + arg2 + ")"
    or
    binary instanceof NEExpr and
    result = "(not (= " + arg1 + " " + arg2 + "))"
  )
}

string interpretExpr(Expr e) {
  result = e.(Access).getTarget().getName()
  or
  exists(UnaryOperation unary | unary = e |
    result = interpretUnaryOperation(unary, unary.getOperand())
  )
  or
  exists(BinaryOperation binary | binary = e |
    result = interpretBinaryOperation(binary, binary.getLeftOperand(), binary.getRightOperand())
  )
}

string interpretGuard(GuardCondition guard) { result = interpretExpr(guard) }

string getANewCondition(BasicBlock b, BasicBlock succ) {
  exists(GuardCondition guard | b.getEnd() = guard |
    guard.isCondition() and
    guard.controls(succ, true) and
    result = interpretGuard(guard)
  )
  or
  exists(GuardCondition guard | b.getEnd() = guard |
    guard.isCondition() and
    guard.controls(succ, false) and
    result = "(not " + interpretGuard(guard) + ")"
  )
}

predicate isSource(ControlFlowNode n) { n.(Call).getTarget().hasName("start") }

predicate isSink(ControlFlowNode n) { n.(Call).getTarget().hasName("end") }

string getACondition(ControlFlowNode n) {
  result = "true"
  or
  exists(GuardCondition guard, boolean b |
    guard.controls(n.getBasicBlock(), b) and
    (
      b = true and
      result = interpretGuard(guard)
      or
      b = false and
      result = "(not " + interpretGuard(guard) + ")"
    )
  )
}

string getCondition(BasicBlock b) {
  exists(int n | n = count(string cond | fwdFlow(b, cond)) |
    n = 1 and fwdFlow(b, result)
    or
    n > 1 and
    result = "(and " + concat(string cond | fwdFlow(b, cond) | cond, " ") + ")"
  )
}

predicate fwdFlow(BasicBlock b, string condition) {
  exists(ControlFlowNode n | b.getANode() = n | isSource(n) and condition = getACondition(n))
  or
  exists(BasicBlock pred, string predCondition |
    b = pred.getASuccessor() and
    fwdFlow(pred, predCondition) and
    condition = [predCondition, getANewCondition(pred, b)]
  )
}

predicate revFlow(BasicBlock b) {
  fwdFlow(b, _) and
  satisfiable(getCondition(b)) and
  (
    exists(ControlFlowNode n | b.getANode() = n | isSink(n))
    or
    revFlow(b.getASuccessor())
  )
}

predicate reach(ControlFlowNode n) {
  revFlow(n.getBasicBlock()) and
  (isSink(n) or reach(n.getASuccessor()))
}

predicate pathSucc(ControlFlowNode n1, ControlFlowNode n2) { n1.getASuccessor() = n2 and reach(n2) }

predicate hasFlow(ControlFlowNode n1, ControlFlowNode n2) = fastTC(pathSucc/2)(n1, n2)

query predicate edges(ControlFlowNode a, ControlFlowNode b) { pathSucc(a, b) }

from ControlFlowNode source, ControlFlowNode sink
where isSource(source) and isSink(sink) and hasFlow(source, sink)
select sink, source, sink, ""
