import csharp
private import semmle.code.csharp.controlflow.Guards

query predicate emptinessCheck(
  Expr check, EnumerableCollectionExpr collection, GuardValue v, boolean isEmpty
) {
  check = collection.getAnEmptinessCheck(v, isEmpty)
}
