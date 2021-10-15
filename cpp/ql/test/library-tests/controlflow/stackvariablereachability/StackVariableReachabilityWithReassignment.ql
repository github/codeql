import cpp
import semmle.code.cpp.controlflow.StackVariableReachability

class MyStackVariableReachability extends StackVariableReachabilityWithReassignment {
  MyStackVariableReachability() { this = "MyStackVariableReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    exprDefinition(v, _, node)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    node.(VariableAccess).getTarget() = v
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) { exprDefinition(v, _, node) }
}

from MyStackVariableReachability svr, ControlFlowNode sink
select sink, strictconcat(Expr source | svr.reaches(source, _, sink) | source.toString(), ", ")
