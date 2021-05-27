/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.controlflow.Guards

newtype TE = TVar(Variable x)

abstract class E extends TE {
  abstract string toString();

  predicate asVar(Variable x) { none() }
}

class Var extends E, TVar {
  Variable x;

  Var() { this = TVar(x) }

  override string toString() { result = x.getName() }

  override predicate asVar(Variable y) { y = x }
}

newtype TF =
  TTrue() or
  TNot(TF f) { f = interpF(_) } or
  TAnd(TF f1, TF f2) {
    exists(LogicalAndExpr conj |
      f1 = interpF(conj.getLeftOperand()) and
      f2 = interpF(conj.getRightOperand())
    )
  } or
  TOr(TF f1, TF f2) {
    exists(LogicalOrExpr disj |
      f1 = interpF(disj.getLeftOperand()) and
      f2 = interpF(disj.getRightOperand())
    )
  } or
  TEq(TE e1, TE e2) {
    exists(EQExpr eq |
      e1 = interpE(eq.getLeftOperand()) and
      e2 = interpE(eq.getRightOperand())
    )
  } or
  TNEq(TE e1, TE e2) {
    exists(NEExpr neq |
      e1 = interpE(neq.getLeftOperand()) and
      e2 = interpE(neq.getRightOperand())
    )
  } or
  TTruthy(TE e)

abstract class F extends TF {
  final string toString() { result = "F" }

  predicate asTrue() { none() }

  predicate asNot(F f) { none() }

  predicate asAnd(F f1, F f2) { none() }

  predicate asOr(F f1, F f2) { none() }

  predicate asEq(E e1, E e2) { none() }

  predicate asNEq(E e1, E e2) { none() }

  predicate asTruthy(E e) { none() }
}

class True extends TTrue, F {
  True() { this = TTrue() }

  override predicate asTrue() { any() }
}

class Not extends TNot, F {
  Not() { this = TNot(_) }

  override predicate asNot(F f) { this = TNot(f) }
}

class And extends TAnd, F {
  And() { this = TAnd(_, _) }

  override predicate asAnd(F f1, F f2) { this = TAnd(f1, f2) }
}

class Or extends TOr, F {
  Or() { this = TOr(_, _) }

  override predicate asOr(F f1, F f2) { this = TOr(f1, f2) }
}

class Eq extends TEq, F {
  Eq() { this = TEq(_, _) }

  override predicate asEq(E e1, E e2) { this = TEq(e1, e2) }
}

class NEq extends TNEq, F {
  NEq() { this = TNEq(_, _) }

  override predicate asNEq(E e1, E e2) { this = TNEq(e1, e2) }
}

class Truthy extends TTruthy, F {
  Truthy() { this = TTruthy(_) }

  override predicate asTruthy(E e) { this = TTruthy(e) }
}

F interpretUnaryOperation(UnaryOperation unary, Expr arg) {
  unary instanceof NotExpr and
  result = TNot(interpF(arg))
}

F interpretBinaryOperation(BinaryOperation binary, Expr arg1, Expr arg2) {
  binary instanceof LogicalAndExpr and
  result = TAnd(interpF(arg1), interpF(arg2))
  or
  binary instanceof LogicalOrExpr and
  result = TOr(interpF(arg1), interpF(arg2))
  or
  binary instanceof EQExpr and
  result = TEq(interpE(arg1), interpE(arg2))
  or
  binary instanceof NEExpr and
  result = TNEq(interpE(arg1), interpE(arg2))
}

F interpF(Expr e) {
  result = TTruthy(interpE(e))
  or
  exists(UnaryOperation unary | unary = e |
    result = interpretUnaryOperation(unary, unary.getOperand())
  )
  or
  exists(BinaryOperation binary | binary = e |
    result = interpretBinaryOperation(binary, binary.getLeftOperand(), binary.getRightOperand())
  )
}

E interpE(Expr e) { result = TVar(e.(Access).getTarget()) }

F interpretGuard(GuardCondition guard) { result = interpF(guard) }

F getANewCondition(BasicBlock b, BasicBlock succ) {
  exists(GuardCondition guard | b.getEnd() = guard |
    guard.isCondition() and
    guard.controls(succ, true) and
    result = interpretGuard(guard)
  )
  or
  exists(GuardCondition guard | b.getEnd() = guard |
    guard.isCondition() and
    guard.controls(succ, false) and
    result = TNot(interpretGuard(guard))
  )
}

predicate isSource(ControlFlowNode n) { n.(Call).getTarget().hasName("start") }

predicate isSink(ControlFlowNode n) { n.(Call).getTarget().hasName("end") }

F getACondition(ControlFlowNode n) {
  result = TTrue()
  or
  exists(GuardCondition guard, boolean b |
    guard.controls(n.getBasicBlock(), b) and
    (
      b = true and
      result = interpretGuard(guard)
      or
      b = false and
      result = TNot(interpretGuard(guard))
    )
  )
}

string stringifyF(F f) {
  f.asTrue() and result = "true"
  or
  exists(F f1 |
    f.asNot(f1) and
    result = "(not " + stringifyF(f1) + ")"
  )
  or
  exists(F f1, F f2 |
    f.asAnd(f1, f2) and
    result = "(and " + stringifyF(f1) + " " + stringifyF(f2) + ")"
  )
  or
  exists(F f1, F f2 |
    f.asOr(f1, f2) and
    result = "(or " + stringifyF(f1) + " " + stringifyF(f2) + ")"
  )
  or
  exists(E e1, E e2 |
    f.asEq(e1, e2) and
    result = "(= " + stringifyE(e1) + " " + stringifyE(e2) + ")"
  )
  or
  exists(E e1, E e2 |
    f.asNEq(e1, e2) and
    result = "(not (= " + stringifyE(e1) + " " + stringifyE(e2) + "))"
  )
  or
  exists(E e |
    f.asTruthy(e) and
    result = stringifyE(e)
  )
}

string stringifyE(E e) { exists(Variable x | e.asVar(x) and result = x.getName()) }

string getCondition(BasicBlock b) {
  exists(int n | n = count(F cond | fwdFlow(b, cond)) |
    n = 1 and result = stringifyF(any(F cond | fwdFlow(b, cond)))
    or
    n > 1 and
    result = "(and " + concat(F cond | fwdFlow(b, cond) | stringifyF(cond), " ") + ")"
  )
}

predicate fwdFlow(BasicBlock b, F condition) {
  exists(ControlFlowNode n | b.getANode() = n | isSource(n) and condition = getACondition(n))
  or
  exists(BasicBlock pred, F predCondition |
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
