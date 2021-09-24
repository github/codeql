import java

query predicate initBlocks(Method m) { m.hasName("<obinit>") }

query predicate initCall(MethodAccess ma) { ma.getMethod().hasName("<obinit>") }

query predicate initExpressions(Expr e, int i) {
  exists(Method m | m.hasName("<obinit>") | e.getParent() = m.getBody() and i = e.getIndex())
}
