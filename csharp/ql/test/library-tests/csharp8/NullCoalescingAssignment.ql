import csharp

query predicate nullcoalescing(NullCoalescingExpr expr) { any() }

query predicate assignments(AssignCoalesceExpr expr, Expr expanded) {
  expanded = expr.getExpandedAssignment()
}
