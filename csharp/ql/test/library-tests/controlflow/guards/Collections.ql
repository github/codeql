import csharp
private import semmle.code.csharp.controlflow.Guards

query predicate emptinessCheck(
  Expr check, CollectionExpr collection, AbstractValue v, boolean isEmpty
) {
  check = collection.getAnEmptinessCheck(v, isEmpty)
}
