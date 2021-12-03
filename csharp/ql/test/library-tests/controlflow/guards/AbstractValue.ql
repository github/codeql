import csharp
private import semmle.code.csharp.controlflow.Guards

query predicate abstractValue(AbstractValue value, Expr e) {
  e = value.getAnExpr() and e.fromSource()
}

query predicate dualValue(AbstractValue value, AbstractValue dual) { dual = value.getDualValue() }

query predicate singletonValue(AbstractValue value) {
  value.isSingleton() and value.getAnExpr().fromSource()
}
