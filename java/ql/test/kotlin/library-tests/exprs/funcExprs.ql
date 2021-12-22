import java

private string getLambdaBody(LambdaExpr le) {
  le.hasExprBody() and result = "expr body"
  or
  le.hasStmtBody() and result = "stmt body"
}

query predicate lambdaExpr(LambdaExpr le, string body, Method m, string signature, AnonymousClass an) {
  getLambdaBody(le) = body and
  le.asMethod() = m and
  signature = m.getSignature() and
  le.getAnonymousClass() = an
}

query predicate memberRefExprs(MemberRefExpr e, Method m, string signature, AnonymousClass an) {
  e.asMethod() = m and
  signature = m.getSignature() and
  e.getAnonymousClass() = an
}
