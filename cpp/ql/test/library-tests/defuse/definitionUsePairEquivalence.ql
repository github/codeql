import cpp
import semmle.code.cpp.controlflow.StackVariableReachability

// Test that def/use algorithm is an instance of StackVariableReachability
class MyDefOrUse extends StackVariableReachability {
  MyDefOrUse() { this = "MyDefUse" }

  override predicate isSource(ControlFlowNode node, StackVariable v) { definition(v, node) }

  override predicate isSink(ControlFlowNode node, StackVariable v) { useOfVar(v, node) }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) { definitionBarrier(v, node) }
}

predicate equivalence() {
  forall(StackVariable v, Expr first, Expr second | definitionUsePair(v, first, second) |
    exists(MyDefOrUse x | x.reaches(first, v, second))
  ) and
  forall(StackVariable v, Expr first, Expr second |
    exists(MyDefOrUse x | x.reaches(first, v, second))
  |
    definitionUsePair(v, first, second)
  )
}

from int i
where if equivalence() then i = 0 else i = 1
select i
