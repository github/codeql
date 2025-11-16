import csharp
private import semmle.code.csharp.controlflow.Guards

query predicate abstractValue(GuardValue value, Expr e) {
  Guards::InternalUtil::exprHasValue(e, value) and e.fromSource()
}
