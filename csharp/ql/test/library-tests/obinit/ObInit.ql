import csharp

query predicate method(ObjectInitMethod m, RefType t) { m.getDeclaringType() = t }

query predicate call(Call c, ObjectInitMethod m, Callable src) {
  c.getTarget() = m and c.getEnclosingCallable() = src
}

predicate scope(Callable callable, ControlFlowNode n, int i) {
  (callable instanceof ObjectInitMethod or callable instanceof Constructor) and
  n.(ControlFlow::EntryNode).getEnclosingCallable() = callable and
  i = 0
  or
  exists(ControlFlowNode prev |
    scope(callable, prev, i - 1) and
    n = prev.getASuccessor() and
    i < 30
  )
}

query predicate cfg(
  Callable callable, ControlFlowNode pred, ControlFlowNode succ, ControlFlow::SuccessorType c, int i
) {
  scope(callable, pred, i) and
  pred.getASuccessor(c) = succ
}
