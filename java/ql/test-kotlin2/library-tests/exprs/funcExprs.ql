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

query predicate lambda_modifiers(LambdaExpr le, Method m, string modifiers) {
  le.getAnonymousClass().getAMethod() = m and
  modifiers = concat(string s | m.hasModifier(s) | s, ", ")
}

query predicate anon_class_member_modifiers(AnonymousClass ac, Method m, string modifiers) {
  ac.getAMethod() = m and
  modifiers = concat(string s | m.hasModifier(s) | s, ", ")
}

query predicate nonOverrideInvoke(LambdaExpr le, Method m, int pCount) {
  le.getAnonymousClass().getAMethod() = m and
  not m.hasModifier("override") and
  m.getName() = "invoke" and
  pCount = m.getNumberOfParameters() and
  exists(Method mOtherInvoke |
    le.getAnonymousClass().getAMethod() = mOtherInvoke and
    mOtherInvoke.hasModifier("override") and
    mOtherInvoke.getName() = "invoke"
  )
}
