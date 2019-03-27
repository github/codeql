import csharp
import semmle.code.csharp.dataflow.Nullness

query predicate alwaysNull(AlwaysNullExpr expr) {
  expr.getEnclosingCallable().getName() = "Nullness"
}

query predicate alwaysNotNull(NonNullExpr expr) {
  expr.getEnclosingCallable().getName() = "Nullness"
}
