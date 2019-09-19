import cpp
import semmle.code.cpp.controlflow.LocalScopeVariableReachability

// Test that def/use algorithm is an instance of LocalScopeVariableReachability
class MyDefOrUse extends LocalScopeVariableReachability {
  MyDefOrUse() { this = "MyDefUse" }

  override predicate isSource(ControlFlowNode node, LocalScopeVariable v) { definition(v, node) }

  override predicate isSink(ControlFlowNode node, LocalScopeVariable v) { useOfVar(v, node) }

  override predicate isBarrier(ControlFlowNode node, LocalScopeVariable v) {
    definitionBarrier(v, node)
  }
}

predicate equivalence() {
  forall(LocalScopeVariable v, Expr first, Expr second | definitionUsePair(v, first, second) |
    exists(MyDefOrUse x | x.reaches(first, v, second))
  ) and
  forall(LocalScopeVariable v, Expr first, Expr second |
    exists(MyDefOrUse x | x.reaches(first, v, second))
  |
    definitionUsePair(v, first, second)
  )
}

from int i
where if equivalence() then i = 0 else i = 1
select i
