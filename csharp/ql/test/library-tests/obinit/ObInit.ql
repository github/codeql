import csharp
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl
import semmle.code.csharp.controlflow.internal.Completion
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowDispatch

query predicate method(ObjectInitMethod m, RefType t) { m.getDeclaringType() = t }

query predicate call(Call c, ObjectInitMethod m, Callable src) {
  c.getTarget() = m and c.getEnclosingCallable() = src
}

predicate scope(Callable callable, AstNode n, int i) {
  (callable instanceof ObjectInitMethod or callable instanceof Constructor) and
  scopeFirst(callable, n) and
  i = 0
  or
  exists(AstNode prev |
    scope(callable, prev, i - 1) and
    succ(prev, n, _) and
    i < 30
  )
}

query predicate cfg(Callable callable, AstNode pred, AstNode succ, Completion c, int i) {
  scope(callable, pred, i) and
  succ(pred, succ, c)
}
