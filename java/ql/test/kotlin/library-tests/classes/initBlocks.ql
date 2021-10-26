import java

query predicate initBlocks(Method m) { m.hasName("<obinit>") }

query predicate initCall(MethodAccess ma) { ma.getMethod().hasName("<obinit>") }

query predicate initExpressions(Expr e, int i) {
  exists(Method m, ExprStmt s | m.hasName("<obinit>") |
    e.getParent() = s and s.getParent() = m.getBody() and i = s.getIndex()
  )
}
